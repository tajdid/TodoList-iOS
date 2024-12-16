//
//  TodoViewModel.swift
//  TodoList
//
//  Created by Taj Rahman on 16/12/2024.
//

import Foundation

class TodoViewModel: ObservableObject {
    @Published var todos: [Todo] = [] {
        didSet {
            saveTodos()
        }
    }
    
    @Published var searchText = ""
    @Published var selectedCategory: String?
    @Published var sortOption: SortOption = .dateCreated
    
    enum SortOption {
        case dateCreated
        case dueDate
        case priority
        case alphabetical
    }
    
    var categories: [String] {
        Array(Set(todos.map { $0.category })).sorted()
    }
    
    var filteredTodos: [Todo] {
        var filtered = todos
        
        // Apply category filter
        if let category = selectedCategory {
            filtered = filtered.filter { $0.category == category }
        }
        
        // Apply search filter
        if !searchText.isEmpty {
            filtered = filtered.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
        
        // Apply sorting
        filtered = filtered.sorted { todo1, todo2 in
            switch sortOption {
            case .dateCreated:
                return todo1.dateCreated > todo2.dateCreated
            case .dueDate:
                guard let date1 = todo1.dueDate, let date2 = todo2.dueDate else {
                    return (todo1.dueDate != nil) ? true : false
                }
                return date1 < date2
            case .priority:
                return todo1.priority.rawValue > todo2.priority.rawValue
            case .alphabetical:
                return todo1.title < todo2.title
            }
        }
        
        return filtered
    }
    
    init() {
        loadTodos()
    }
    
    func addTodo(title: String, dueDate: Date?, priority: Priority, category: String) {
        let todo = Todo(title: title, dueDate: dueDate, priority: priority, category: category)
        todos.append(todo)
    }
    
    func toggleTodo(_ todo: Todo) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[index].isCompleted.toggle()
        }
    }
    
    func deleteTodo(_ todo: Todo) {
        todos.removeAll(where: { $0.id == todo.id })
    }
    
    func updateTodo(_ todo: Todo, title: String, dueDate: Date?, priority: Priority, category: String) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[index].title = title
            todos[index].dueDate = dueDate
            todos[index].priority = priority
            todos[index].category = category
        }
    }
    
    private func loadTodos() {
        if let data = UserDefaults.standard.data(forKey: "todos") {
            do {
                let decoder = JSONDecoder()
                todos = try decoder.decode([Todo].self, from: data)
            } catch {
                print("Error loading todos: \(error)")
            }
        }
    }
    
    private func saveTodos() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(todos)
            UserDefaults.standard.set(data, forKey: "todos")
        } catch {
            print("Error saving todos: \(error)")
        }
    }
}
