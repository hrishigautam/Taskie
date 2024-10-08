//
//  Persistence.swift
//  Taskie
//
//  Created by Hrishi Gautam on 06/10/24.
//

// Persistence.swift

import Foundation

class Persistence {
    static let shared = Persistence()
    
    private init() {}
    
    func saveTasks(_ tasks: [Task]) {
        do {
            let data = try JSONEncoder().encode(tasks)
            UserDefaults.standard.set(data, forKey: "tasks")
        } catch {
            print("Failed to save tasks: \(error.localizedDescription)")
        }
    }
    
    func loadTasks() -> [Task] {
        guard let data = UserDefaults.standard.data(forKey: "tasks") else { return [] }
        do {
            return try JSONDecoder().decode([Task].self, from: data)
        } catch {
            print("Failed to load tasks: \(error.localizedDescription)")
            return []
        }
    }
}
