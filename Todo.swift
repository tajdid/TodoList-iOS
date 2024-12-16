//
//  Todo.swift
//  TodoList
//
//  Created by Taj Rahman on 16/12/2024.
//

import Foundation

enum Priority: String, Codable, CaseIterable {
    case high = "High"
    case medium = "Medium"
    case low = "Low"
}

struct Todo: Identifiable, Codable {
    var id: UUID
    var title: String
    var isCompleted: Bool
    var dateCreated: Date
    var dueDate: Date?
    var priority: Priority
    var category: String
    
    init(title: String,
         isCompleted: Bool = false,
         dateCreated: Date = Date(),
         dueDate: Date? = nil,
         priority: Priority = .medium,
         category: String = "Default") {
        self.id = UUID()
        self.title = title
        self.isCompleted = isCompleted
        self.dateCreated = dateCreated
        self.dueDate = dueDate
        self.priority = priority
        self.category = category
    }
}
