//
//  ExpenseTrackerApp.swift
//  ExpenseTracker
//
//  Created by Saurabh Jaiswal on 21/05/25.
//

import SwiftUI
import SwiftData

@main
struct ExpenseTrackerApp: App {
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([Expense.self])
        let config = ModelConfiguration(schema: schema)
        return try! ModelContainer(for: schema, configurations: [config])
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView().modelContainer(sharedModelContainer)
        }
    }
}
