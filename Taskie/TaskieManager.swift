//
//  TaskieManager.swift
//  Taskie
//
//  Created by Hrishi Gautam on 06/10/24.
//


import Foundation
import Combine

class TaskieManager: ObservableObject {
    @Published var todaysTasks: [Task] = []
    @Published var pendingTasks: [Task] = []
    @Published var completedTasks: [Task] = []
    @Published var showingAddTask = false

    private var cancellables: Set<AnyCancellable> = []
    private let timer: Publishers.Autoconnect<Timer.TimerPublisher>

    init() {
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        
        timer.sink { [weak self] _ in
            self?.updateTasks()
        }.store(in: &cancellables)

        loadTasks()
    }

    func addTask(title: String, deadline: Date) {
        let newTask = Task(title: title, deadline: deadline)
        if newTask.isOverdue {
            pendingTasks.append(newTask)
        } else {
            todaysTasks.append(newTask)
        }
        saveTasks()
    }

    func updateTasks() {
        let currentDate = Date()
        
        todaysTasks.forEach { task in
            task.updateRemainingTime(currentDate: currentDate)
            if task.isOverdue {
                pendingTasks.append(task)
            }
        }
        todaysTasks.removeAll { $0.isOverdue }
        
        pendingTasks.forEach { $0.updateRemainingTime(currentDate: currentDate) }
        
        todaysTasks.sort { $0.deadline < $1.deadline }
        pendingTasks.sort { $0.deadline < $1.deadline }
        
        objectWillChange.send()
        saveTasks()
    }

    func completeTask(_ task: Task) {
        if let index = todaysTasks.firstIndex(where: { $0.id == task.id }) {
            let completedTask = todaysTasks.remove(at: index)
            completedTask.complete()
            completedTasks.append(completedTask)
        } else if let index = pendingTasks.firstIndex(where: { $0.id == task.id }) {
            let completedTask = pendingTasks.remove(at: index)
            completedTask.complete()
            completedTasks.append(completedTask)
        }
        
        cleanupHistory()
        saveTasks()
    }

    func cleanupHistory() {
        if completedTasks.count > 20 {
            completedTasks = Array(completedTasks.suffix(20))
        }
    }

    private func saveTasks() {
        let allTasks = todaysTasks + pendingTasks + completedTasks
        Persistence.shared.saveTasks(allTasks)
    }

    private func loadTasks() {
        let loadedTasks = Persistence.shared.loadTasks()
        todaysTasks = loadedTasks.filter { !$0.isOverdue && !$0.isCompleted }
        pendingTasks = loadedTasks.filter { $0.isOverdue && !$0.isCompleted }
        completedTasks = loadedTasks.filter { $0.isCompleted }
        cleanupHistory()
    }
}
