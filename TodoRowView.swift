//
//  TodoRowView.swift
//  TodoList
//
//  Created by Taj Rahman on 16/12/2024.
//

import SwiftUI

struct TodoRowView: View {
    let todo: Todo
    let toggleAction: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(todo.isCompleted ? .green : .gray)
                    .onTapGesture(perform: toggleAction)
                
                VStack(alignment: .leading) {
                    Text(todo.title)
                        .strikethrough(todo.isCompleted)
                    
                    HStack {
                        if let dueDate = todo.dueDate {
                            HStack {
                                Image(systemName: "calendar")
                                Text(dueDate, style: .date)
                            }
                            .font(.caption)
                            .foregroundColor(isDueDateOverdue(dueDate) ? .red : .gray)
                        }
                        
                        Text(todo.priority.rawValue)
                            .font(.caption)
                            .padding(4)
                            .background(priorityColor(todo.priority).opacity(0.2))
                            .cornerRadius(4)
                        
                        Text(todo.category)
                            .font(.caption)
                            .padding(4)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(4)
                    }
                }
            }
        }
    }
    
    private func isDueDateOverdue(_ date: Date) -> Bool {
        date < Date()
    }
    
    private func priorityColor(_ priority: Priority) -> Color {
        switch priority {
        case .high: return .red
        case .medium: return .orange
        case .low: return .blue
        }
    }
}
