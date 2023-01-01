//
//  FinanceDashboardApp.swift
//  FinanceDashboard
//
//  Created by 顾艳华 on 2023/1/1.
//

import SwiftUI

@main
struct FinanceDashboardApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
