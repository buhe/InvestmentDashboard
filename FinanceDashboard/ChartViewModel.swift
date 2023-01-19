//
//  ChartViewModel.swift
//  FinanceDashboard
//
//  Created by 顾艳华 on 2023/1/14.
//

import Foundation
import SwiftUI
import CoreData

class ChartViewModel: ObservableObject {
    @Published var model: Model = Model.shared
    
    func byCategory(items: FetchedResults<Item>) -> [String: [Chart]] {
        // todo when name same remove dup, updateDate newer win
        var result: [String: [Chart]] = [:]
        for item in items {
            let categroy = item.categroy ?? ""
            if result[categroy] == nil {
                result[categroy] = []
            }
            let sameName = result[categroy]!.filter{$0.name == (item.name ?? "")}
            
            if sameName.isEmpty {
                // not found
                result[categroy]!.append(Chart(name: item.name ?? "", categroy: ICategroy(rawValue: item.categroy ?? "") ?? .UnKnow, unit:  Unit(rawValue: item.unit ?? "") ?? .UnKnow, value: item.value,updateDate: item.updatedDate!))
            } else {
                if sameName.first!.updateDate < item.updatedDate! {
                    // when newer value update
                    result[categroy]!.removeAll{$0.name == (item.name ?? "")}
                    result[categroy]!.append(Chart(name: item.name ?? "", categroy: ICategroy(rawValue: item.categroy ?? "") ?? .UnKnow, unit:  Unit(rawValue: item.unit ?? "") ?? .UnKnow, value: item.value,updateDate: item.updatedDate!))
                }
            }
        }
        return result
    }
//    func byCategoryLabel(items: FetchedResults<Item>) -> [String] {
//        self.byCategory(items: items)
//            .map{
//                k,v in
//                k
//            }
//    }
    func byCategroySync(items: FetchedResults<Item>) -> [Double] {
        return self.byCategory(items: items)
            .map{
                k,v in
                var total: Double = 0
                v.forEach{
                    i in
//                    if i.unit == model.unit {
                        total = total + i.value
//                    } else {
//                        print("chart categroy transfer currency")
//                        let new = await CurrencySDK.transfer(origion: (i.value, i.unit), to: model.unit)
//                        total = total + new.0
//                    }
                    
                }
                return total
                
            }
    }
    func byCategoryValue(items: FetchedResults<Item>, viewContext: NSManagedObjectContext) async -> [Double] {
        return await self.byCategory(items: items)
            .asyncMap{
                k,v in
                var total: Double = 0
                await v.asyncForEach{
                    i in
                    if i.unit == model.unit {
                        total = total + i.value
                    } else {
                        print("chart categroy transfer currency")
                        let new = await CurrencySDK.transfer(origion: (i.value, i.unit), to: model.unit, viewContext: viewContext)
                        total = total + new.0
                    }
                    
                }
                return total
                
            }
    }
    func byDate(items: FetchedResults<Item>) async -> Array<(key: String, value: Array<Chart>)> {
        // todo when name same and mouth same remove dup, updateDate newer win
        var result: [String: [Chart]] = [:]
        var minTime: Date = Date.now
        for item in items {
            let time = itemFormatter.string(from: item.updatedDate!)
            if item.updatedDate! < minTime {
                minTime = item.updatedDate!
            }
            if result[time] == nil {
                result[time] = []
            }
            let sameName = result[time]!.filter{$0.name == (item.name ?? "")}
            
            if sameName.isEmpty {
                // not found
                result[time]!.append(Chart(name: item.name ?? "", categroy: ICategroy(rawValue: item.categroy ?? "") ?? .UnKnow, unit:  Unit(rawValue: item.unit ?? "") ?? .UnKnow, value: item.value,updateDate: item.updatedDate!))
            } else {
                if sameName.first!.updateDate < item.updatedDate! {
                    // when newer value update
                    result[time]!.removeAll{$0.name == (item.name ?? "")}
                    result[time]!.append(Chart(name: item.name ?? "", categroy: ICategroy(rawValue: item.categroy ?? "") ?? .UnKnow, unit:  Unit(rawValue: item.unit ?? "") ?? .UnKnow, value: item.value,updateDate: item.updatedDate!))
                }
            }
        }
        if result.count < 10 {
//            let now = Date.now
            for i in 1...(10 - result.count) {
                let previousMonth = Calendar.current.date(byAdding: .month, value: -i, to: minTime)!
                let time = itemFormatter.string(from: previousMonth)
                result[time] = [Chart(name: "Empty", categroy: .UnKnow,unit: .UnKnow, value: 0, updateDate: Date.now )]
            }
            
        }
        return result.sorted(by: {a,b in (a.key.compare(b.key)).rawValue < 0})
    }
    
    func byDateValue(items: FetchedResults<Item>, viewContext: NSManagedObjectContext) async -> [Double] {
        let dates = await self.byDate(items: items).asyncMap {
            k,v in
            var total: Double = 0
            await v.asyncForEach{
                i in
                if i.unit == model.unit {
                    total = total + i.value
                } else {
                    print("chart date transfer currency")
                    let new = await CurrencySDK.transfer(origion: (i.value, i.unit), to: model.unit, viewContext: viewContext)
                    total = total + new.0
                }
                
                
            }
//            print("Date: \(k) \(total)")
            return total
        }
        // todo
        // 1 by time
        // 2 corrot time
        return dates.sorted{a,b in a < b}
//        return dates
    }
}



struct Chart {
    let name: String
    let categroy: ICategroy
    let unit: Unit
    let value: Double
    let updateDate: Date
}
