//
//  FinanceDashboardApp.swift
//  FinanceDashboard
//
//  Created by 顾艳华 on 2023/1/1.
//

import SwiftUI
import StoreKit

@main
struct FinanceDashboardApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        SKPaymentQueue.default().add(IAPManager.shared)

        CurrencySDK.loadCache(viewContext: persistenceController.container.viewContext)
        return WindowGroup {
            ContentView(overViewModel: OverViewModel(), chartViewModel: ChartViewModel())
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
