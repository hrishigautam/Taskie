//
//  HistoryView.swift
//  Taskie
//
//  Created by Hrishi Gautam on 06/10/24.
//

import SwiftUI

struct HistoryView: View {
    @ObservedObject var taskManager: TaskieManager
    
    var body: some View {
        List {
            ForEach(taskManager.completedTasks) { task in
                HStack {
                    Text(task.title)
                    Spacer()
                    Text(task.deadline, style: .date)
                        .foregroundColor(.gray)
                }
            }
        }
        .navigationTitle("Task History")
    }
}
