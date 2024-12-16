//
//  ContentView.swift
//  TodoList
//
//  Created by Taj Rahman on 16/12/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = TodoViewModel()
    @State private var isAddingNewTodo = false
    @State private var newTodoTitle = ""
    @State private var newTodoDueDate: Date? = nil
    @State private var newTodoPriority: Priority = .medium
    @State private var newTodoCategory = ""
    @State private var isShowingFilters = false
    
    var body: some View {
        NavigationView {
            VStack {
                // Search bar
                SearchBar(text: $viewModel.searchText)
                    .padding()
                
                // Filters and sorting
                HStack {
                    Menu {
                        Picker("Sort by", selection: $viewModel.sortOption) {
                            Text("Date Created").tag(TodoViewModel.SortOption.dateCreated)
                            Text("Due Date").tag(TodoViewModel.SortOption.dueDate)
                            Text("Priority").tag(TodoViewModel.SortOption.priority)
                            Text("Alphabetical").tag(TodoViewModel.SortOption.alphabetical)
                        }
                    } label: {
                        Label("Sort", systemImage: "arrow.up.arrow.down")
                    }
                    
                    Menu {
                        ForEach(["All"] + viewModel.categories, id: \.self) { category in
                            Button {
                                viewModel.selectedCategory = category == "All" ? nil : category
                            } label: {
                                Text(category)
                            }
                        }
                    } label: {
                        Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                    }
                }
                .padding(.horizontal)
                
                // Todo list
                List {
                    ForEach(viewModel.filteredTodos) { todo in
                        TodoRowView(todo: todo) {
                            viewModel.toggleTodo(todo)
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                viewModel.deleteTodo(todo)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Todo List")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isAddingNewTodo = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isAddingNewTodo) {
                NavigationView {
                    Form {
                        TextField("Title", text: $newTodoTitle)
                        
                        DatePicker("Due Date",
                                 selection: Binding(
                                    get: { newTodoDueDate ?? Date() },
                                    set: { newTodoDueDate = $0 }
                                 ),
                                 displayedComponents: [.date])
                        
                        Picker("Priority", selection: $newTodoPriority) {
                            ForEach(Priority.allCases, id: \.self) { priority in
                                Text(priority.rawValue).tag(priority)
                            }
                        }
                        
                        TextField("Category", text: $newTodoCategory)
                    }
                    .navigationTitle("New Todo")
                    .navigationBarItems(
                        leading: Button("Cancel") {
                            isAddingNewTodo = false
                        },
                        trailing: Button("Add") {
                            if !newTodoTitle.isEmpty {
                                viewModel.addTodo(
                                    title: newTodoTitle,
                                    dueDate: newTodoDueDate,
                                    priority: newTodoPriority,
                                    category: newTodoCategory.isEmpty ? "Default" : newTodoCategory
                                )
                                newTodoTitle = ""
                                newTodoDueDate = nil
                                newTodoPriority = .medium
                                newTodoCategory = ""
                                isAddingNewTodo = false
                            }
                        }
                    )
                }
            }
        }
    }
}

// Search bar component
struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search todos...", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
