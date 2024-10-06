//
//  TaskieApp.swift
//  Taskie
//
//  Created by Hrishi Gautam on 06/10/24.
//

import SwiftUI

@main
struct TaskieApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
