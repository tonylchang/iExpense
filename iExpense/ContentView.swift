//
//  ContentView.swift
//  iExpense
//
//  Created by Tony Chang on 8/24/24.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}

@Observable
class Expenses {
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }

        items = []
    }
    
    var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
}

struct ContentView: View {
    
    @State private var expenses = Expenses()
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationStack {
            List {
                Section("Business") {
                    ForEach(expenses.items) { item in
                        if item.type == "Business" {
                            HStack {
                                VStack {
                                    Text(item.name)
                                    Text(item.type)
                                }
                                Spacer()
                                Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                            }
                            .opacity((item.amount <= 10) ? 0.5 : 1.0)
                            .foregroundColor(
                                (item.amount <= 100) ? (item.amount <= 10 ? .green : .blue) : .red
                            )
                            .font(Font.headline.weight((item.amount > 100) ? .heavy : .regular))
                        }
                    }
                    .onDelete(perform: removeItems)
                }
                
                Section("Personal") {
                    ForEach(expenses.items) { item in
                        if item.type == "Personal" {
                            HStack {
                                VStack {
                                    Text(item.name)
                                    Text(item.type)
                                }
                                Spacer()
                                Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                            }
                            .opacity((item.amount <= 10) ? 0.5 : 1.0)
                            .foregroundColor(
                                (item.amount <= 100) ? (item.amount <= 10 ? .green : .blue) : .red
                            )
                            .font(Font.headline.weight((item.amount > 100) ? .heavy : .regular))
                        }
                    }
                    .onDelete(perform: removeItems)
                }
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button("Add Expense", systemImage: "plus") {
                    showingAddExpense = true
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddView(expenses: expenses)
            }
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        
        expenses.items.remove(atOffsets: offsets)
        
    }
}

#Preview {
    ContentView()
}
