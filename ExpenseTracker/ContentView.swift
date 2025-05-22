//
//  ContentView.swift
//  ExpenseTracker
//
//  Created by Saurabh Jaiswal on 21/05/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var expenses: [Expense]
    @State private var selectedExpense: Expense?
    @State private var showAddExpense = false
    @State private var selectedCurrency = "₹"
    @State private var selectedExpenseId: UUID?
    
    let currencySymbol = ["$", "₹", "€", "£", "¥", "₽", "R$"]
    
    var totalIncome: Double {
        expenses.filter { $0.isIncome }.reduce(0) { $0 + $1.amount }
    }
    
    var totalExpense: Double {
        expenses.filter { !$0.isIncome }.reduce(0) { $0 + $1.amount }
    }
    
    var totalBalance: Double {
        totalIncome - totalExpense
    }
    
    let categories: [String : String] = [
        "Food" : "fork.knife",
        "Travel" : "airplane",
        "Shopping" : "cart",
        "Bills" : "doc.text",
        "Salary" : "creditcard",
        "Transport" : "truck.box.fill",
        "Miscellaneous" : "ellipsis"
    ]
    
    var groupedTransactions: [(String, [Expense])] {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        
        return Dictionary(grouping: expenses) { expense in
            formatter.string(from: expense.date)
        }
        .sorted { lhs, rhs in
            if let lhsDate = formatter.date(from: lhs.key),
               let rhsDate = formatter.date(from: rhs.key) {
                return lhsDate > rhsDate
            }
            return false
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea()
                    
                    VStack(spacing: 10) {
                        Text("Expenses Tracker")
                            .font(.largeTitle)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        
                        Picker("Currency", selection: $selectedCurrency) {
                            ForEach(currencySymbol, id: \.self) { symbol in
                                Text(symbol)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal)
                        
                        Text("\(selectedCurrency) \(totalBalance, specifier: "%.2f")")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        HStack(spacing: 20) {
                            incomeExpenseView(
                                title: "Income",
                                amount: totalIncome,
                                icon: "arrow.up.right.circle.fill",
                                color: .green
                            )
                            
                            Spacer()
                            
                            incomeExpenseView(
                                title: "Expense",
                                amount: totalExpense,
                                icon: "arrow.up.down.circle.fill",
                                color: .red
                            )
                        }
                        .padding(.horizontal)
                    }
                    .frame(maxWidth: .infinity, alignment: .top)
                }
                .frame(maxHeight: 200, alignment: .top)
                .edgesIgnoringSafeArea(.bottom)
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("Transactions")
                            .font(.title).bold()
                        Spacer()
                    }
                }
                .padding()
                
                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(groupedTransactions, id: \.0) { date, expensesForDate in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(date)
                                    .font(.headline)
                                    .padding(.horizontal)
                                    .foregroundStyle(.gray)
                                
                                ForEach(expensesForDate) { expense in
                                    transactionRow(expense)
                                }
                            }
                        }
                    }
                }
            }
            .toolbar {
                NavigationLink(destination: AddExpenseView(selectedCurreny: selectedCurrency)) {
                    Image(systemName: "plus")
                }
            }
            .fullScreenCover(item: $selectedExpense) { expense in
                AddExpenseView(selectedCurreny: selectedCurrency, expenseToEdit: expense)
            }
        }
    }
    
    @ViewBuilder
    private func incomeExpenseView(title: String, amount: Double, icon: String, color: Color) -> some View {
        HStack {
            Image(systemName: icon)
                .font(.title)
                .foregroundStyle(color)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(color)
                
                Text("\(selectedCurrency) \(amount, specifier: "%.2f")")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(color)
            }
        }
    }
    
    @ViewBuilder
    private func transactionRow(_ expense: Expense) -> some View {
        HStack {
            ZStack {
                UnevenRoundedRectangle(topLeadingRadius: 12, bottomLeadingRadius: 12)
                    .fill(expense.isIncome ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: categories[expense.category] ?? "questionmark.circle")
                    .foregroundStyle(expense.isIncome ? .green : .red)
                    .font(.title2)
            }
            .offset(x: -10)
            
            VStack(alignment: .leading) {
                Text(expense.title)
                    .font(.headline)
                    .foregroundStyle(Color(.label))
                Text(expense.category)
                    .font(.subheadline)
                    .foregroundStyle(Color(.secondaryLabel))
            }
            
            Spacer()
            
            Text("\(expense.isIncome ? "+" : "-")\(selectedCurrency) \(expense.amount, specifier: "%.0f")")
                .foregroundStyle(expense.isIncome ? .green : .red)
        }
        .padding(.vertical, 4)
        .padding(.horizontal)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
        .padding(.horizontal)
        .contextMenu {
            Button("Edit") {
                selectedExpense = expense
            }
            Button("Delete", role: .destructive) {
                deleteExpense(expense)
            }
        }
    }
    
    private func deleteExpense(_ expense: Expense) {
        modelContext.delete(expense)
    }
}

#Preview {
    ContentView()
}
