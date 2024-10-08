//
//  AddTaskView.swift
//  Taskie
//
//  Created by Hrishi Gautam on 08/10/24.
//

import SwiftUI

struct AddTaskView: View {
    @ObservedObject var taskManager: TaskieManager
    @State private var title = ""
    @State private var deadline = Date()
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                TextField("Task Title", text: $title)
                DatePicker("Deadline", selection: $deadline, in: Date()...)
            }
            .navigationTitle("Add New Task")
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Add") {
                    taskManager.addTask(title: title, deadline: deadline)
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(title.isEmpty)
            )
        }
    }
}
