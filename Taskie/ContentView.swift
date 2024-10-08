//
//  ContentView.swift
//  Taskie
//
//  Created by Hrishi Gautam on 06/10/24.
//



import SwiftUI

struct ContentView: View {
    @StateObject var taskManager = TaskieManager()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    TaskSection(title: "PENDING TASKS", color: .red, tasks: taskManager.pendingTasks)
                    TaskSection(title: "CURRENT TASKS", color: .gray, tasks: taskManager.todaysTasks)
                    
                    if taskManager.pendingTasks.isEmpty && taskManager.todaysTasks.isEmpty {
                        Text("No tasks yet. Add a new task to get started!")
                            .foregroundColor(.gray)
                            .padding()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("HrG's Taskie")
                        .font(.headline)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Button(action: {
                            taskManager.showingAddTask = true
                        }) {
                            Image(systemName: "plus")
                                .foregroundColor(.blue)
                        }
                        
                        NavigationLink(destination: HistoryView(taskManager: taskManager)) {
                            Text("History")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .sheet(isPresented: $taskManager.showingAddTask) {
                AddTaskView(taskManager: taskManager)
            }
        }
        .environmentObject(taskManager)
    }
}

struct TaskSection: View {
    let title: String
    let color: Color
    let tasks: [Task]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.headline)
                .foregroundColor(color)
                .padding(.top, 20)
                .padding(.leading, 20)
            
            if tasks.isEmpty {
                Text("No tasks")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ForEach(tasks) { task in
                    TaskRowView(task: task)
                        .padding(.horizontal)
                }
            }
        }
    }
}

struct TaskRowView: View {
    @ObservedObject var task: Task
    @EnvironmentObject var taskManager: TaskieManager

    var body: some View {
        HStack {
            Button(action: {
                taskManager.completeTask(task)
            }) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isCompleted ? .green : .blue)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.body)
                Text("Deadline: \(task.deadlineTimeString)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
            Text(task.remainingTimeString)
                .font(.caption)
                .foregroundColor(task.isOverdue ? .red : .orange)
        }
        .padding(.vertical, 8)
    }
}
