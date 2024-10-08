//
//  Taskie.swift
//  Taskie
//
//  Created by Hrishi Gautam on 07/10/24.
//
import Foundation

class Task: Identifiable, ObservableObject, Codable {
    let id: UUID
    let title: String
    let deadline: Date
    @Published var isCompleted: Bool
    @Published var remainingTimeString: String
    @Published var isOverdue: Bool

    init(id: UUID = UUID(), title: String, deadline: Date) {
        self.id = id
        self.title = title
        self.deadline = deadline
        self.isCompleted = false
        self.remainingTimeString = ""
        self.isOverdue = false
        updateRemainingTime(currentDate: Date())
    }

    var deadlineTimeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy 'at' h:mm a"
        return formatter.string(from: deadline)
    }

    func updateRemainingTime(currentDate: Date) {
        let remainingTime = deadline.timeIntervalSince(currentDate)
        isOverdue = remainingTime < 0

        if isOverdue {
            remainingTimeString = "Overdue"
        } else {
            let hours = Int(remainingTime) / 3600
            let minutes = (Int(remainingTime) % 3600) / 60
            let seconds = Int(remainingTime) % 60
            remainingTimeString = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
    }

    func complete() {
        isCompleted = true
    }

    enum CodingKeys: String, CodingKey {
        case id, title, deadline, isCompleted
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        deadline = try container.decode(Date.self, forKey: .deadline)
        isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
        remainingTimeString = ""
        isOverdue = false
        updateRemainingTime(currentDate: Date())
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(deadline, forKey: .deadline)
        try container.encode(isCompleted, forKey: .isCompleted)
    }
}
