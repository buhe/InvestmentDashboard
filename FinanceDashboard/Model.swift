//
//  Model.swift
//  FinanceDashboard
//
//  Created by 顾艳华 on 2023/1/15.
//

import Foundation
import SwiftUI
import CoreData

enum ICategroy: String, CaseIterable, Identifiable {
    var id: Self {

        return self
    }
    case Cash
    case Estate
    case Stock
    case Option
    case Bond
    case Fund
    case Futures
    case Debt // -
    case Savings
    case UnKnow
    
    static var all: [ICategroy] {
        ICategroy.allCases.filter {$0 != .UnKnow}
    }
}

struct Model {
    @AppStorage(wrappedValue: Unit.USD, "unit") var unit: Unit
    @AppStorage(wrappedValue: false, "face") var faceIdEnable: Bool
    @AppStorage(wrappedValue: false, "iap") var iap: Bool
    @AppStorage(wrappedValue: true, "first") var first: Bool
    @AppStorage(wrappedValue: 25, "age") var age: Int
    @AppStorage(wrappedValue: false, "incldueEstate") var incldueEstate: Bool
    
    func tryLoadDemo(viewContext: NSManagedObjectContext) {
        let items = try! viewContext.fetch(NSFetchRequest(entityName: "Item")) as! [Item]
        if first && items.isEmpty {
            let newItem = Item(context: viewContext)
            newItem.name = "base"
            newItem.value = 999
            newItem.unit = Unit.USD.rawValue
            newItem.categroy = ICategroy.Cash.rawValue
            newItem.createdDate = Date.now
            newItem.updatedDate = Date.now
            
            let newItem1 = Item(context: viewContext)
            newItem1.name = "base"
            newItem1.value = 9999
            newItem1.unit = Unit.USD.rawValue
            newItem1.categroy = ICategroy.Cash.rawValue
            newItem1.createdDate = Date.now
            newItem1.updatedDate = Calendar.current.date(byAdding: .month, value: -1, to: Date.now)!
            
            let newItem2 = Item(context: viewContext)
            newItem2.name = "cd"
            newItem2.value = 9999
            newItem2.unit = Unit.JPY.rawValue
            newItem2.categroy = ICategroy.Savings.rawValue
            newItem2.createdDate = Date.now
            newItem2.updatedDate = Date.now
            
            let newItem4 = Item(context: viewContext)
            newItem4.name = "cd"
            newItem4.value = 99996
            newItem4.unit = Unit.JPY.rawValue
            newItem4.categroy = ICategroy.Savings.rawValue
            newItem4.createdDate = Date.now
            newItem4.updatedDate = Calendar.current.date(byAdding: .month, value: -1, to: Date.now)!
            
            let newItem5 = Item(context: viewContext)
            newItem5.name = "Tech inc."
            newItem5.value = 9999
            newItem5.unit = Unit.JPY.rawValue
            newItem5.categroy = ICategroy.Stock.rawValue
            newItem5.createdDate = Date.now
            newItem5.updatedDate = Date.now
            
            let newItem6 = Item(context: viewContext)
            newItem6.name = "Tech inc."
            newItem6.value = 99996
            newItem6.unit = Unit.JPY.rawValue
            newItem6.categroy = ICategroy.Stock.rawValue
            newItem6.createdDate = Date.now
            newItem6.updatedDate = Calendar.current.date(byAdding: .month, value: -1, to: Date.now)!
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
        first = false
    }
    
    static let shared: Model = Model()
}

enum Unit: String, CaseIterable {
    case CNY
    case AUD
    case USD
    case EUR
    case GBP
    case JPY
//    case TWD
    case ARS
    case HKD
    case SGD
    case CHF
    case UnKnow
}
