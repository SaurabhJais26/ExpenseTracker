//
//  AddExpenseView.swift
//  ExpenseTracker
//
//  Created by Saurabh Jaiswal on 21/05/25.
//

import SwiftUI

struct AddExpenseView: View {
    @Environment(\.modelContext) private var modelContext
    
    var selectedCurrency: String
    var expenseToEdit: Expense?
    
    @State private var isIncome = false
    @State private var amountText = ""
    @State private var title = ""
    @State private var date = Date()
    @State private var selectedCategory = "Transport"
    @FocusState private var isKeyboardVisible: Bool
    
    let categories: [String : String] = [
        "Food" : "🍽️",
        "Travel" : "🚗",
        "Shopping" : "🛍️",
        "Bills" : "💸",
        "Salary" : "💼",
        "Entertainment" : "🎮",
        "Transport" : "🚌",
        "Miscellaneous" : "✋"
    ]
    
    init(selectedCurreny: String, expenseToEdit: Expense? = nil) {
        self.selectedCurrency = selectedCurreny
        self.expenseToEdit = expenseToEdit
        _title = State(initialValue: expenseToEdit?.title ?? "")
        _amountText = State(initialValue: expenseToEdit?.amount.description ?? "")
        _date = State(initialValue: expenseToEdit?.date ?? Date())
        _selectedCategory = State(initialValue: expenseToEdit?.category ?? "Transport")
        _isIncome = State(initialValue: expenseToEdit?.isIncome ?? false)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 20) {
                    Text(expenseToEdit == nil ? "Add Expense" : "Edit Expense")
                        .font(.title).bold()
                    
                    HStack {
                        Button(action: { isIncome = false }) {
                            HStack {
                                Image(systemName: "arrow.down.backward")
                                Text("Expense")
                            }
                            .font(.title2)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isIncome ? Color.gray.opacity(0.2) : Color.red.opacity(0.3))
                            .foregroundStyle(isIncome ? .black : .red)
                            .cornerRadius(10)
                        }
                        
                        Button(action: { isIncome = true }) {
                            HStack {
                                Image(systemName: "arrow.up.forward")
                                Text("Income")
                            }
                            .font(.title2)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isIncome ? Color.green.opacity(0.3) : Color.gray.opacity(0.2))
                            .foregroundStyle(isIncome ? .green : .black)
                            .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Amount Input
                    VStack {
                        HStack {
                            Text(selectedCurrency)
                                .font(.system(size: 32))
                                .fontWeight(.bold)
                            
                            TextField("0.00", text: $amountText)
                                .font(.system(size: 28))
                                .foregroundStyle(isIncome ? .green : .red)
                                .keyboardType(.decimalPad)
                                .focused($isKeyboardVisible)
                        }
                        .padding(.horizontal)
                        Divider()
                        
                        TextField("Title", text: $title)
                            .font(.system(size: 24))
                            .textFieldStyle(.roundedBorder)
                            .padding(.horizontal)
                            .focused($isKeyboardVisible)
                            .padding(.vertical, 8)
                        
                        VStack {
                            HStack {
                                Text("Category")
                                Spacer()
                                Menu {
                                    ForEach(categories.keys.sorted(), id: \.self) { category in
                                        Button(action: {
                                            selectedCategory = category
                                        }) {
                                            Label(category, systemImage: categories[category] ?? "questionmark.circle")
                                        }
                                    }
                                } label: {
                                    Label(selectedCategory, systemImage: categories[selectedCategory] ?? "questionmark.circle")
                                        .padding(.vertical, 6)
                                        .padding(.horizontal, 12)
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(8)
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(.vertical, 8)
                        
                        DatePicker("Date", selection: $date, displayedComponents: .date)
                            .padding()
                    }
                    .padding(.vertical, 8)
                    .background(LinearGradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .cornerRadius(25)
                    .padding(.horizontal)
                }
            }
        }
    }
}

