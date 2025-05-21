//
//  Model.swift
//  ExpenseTracker
//
//  Created by Saurabh Jaiswal on 21/05/25.
//

import Foundation
import SwiftData

@Model
class Expense: Identifiable {
    var id: UUID = UUID()
    var title: String
    var amount: Double
    var date: Date
    var category: String
    var isIncome: Bool
    
    init(title: String, amount: Double, date: Date, category: String, isIncome: Bool) {
        self.title = title
        self.amount = amount
        self.date = date
        self.category = category
        self.isIncome = isIncome
    }
}
