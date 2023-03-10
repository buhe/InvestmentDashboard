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
        IAPManager.shared.getProducts()

        CurrencySDK.loadCache(viewContext: persistenceController.container.viewContext)
        return WindowGroup {
            ContentView(overViewModel: OverViewModel(), chartViewModel: ChartViewModel(), analysisViewModel: AnalysisViewModel())
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
