//
//  OverViewModel.swift
//  FinanceDashboard
//
//  Created by 顾艳华 on 2023/1/14.
//

import Foundation
import SwiftUI
import CoreData

class OverViewModel: ObservableObject {
    @Published var model: Model = Model.shared
    func byChangeMonitor(items: FetchedResults<Item>) -> [OverviewWithoutRaw] {
        items.map{OverviewWithoutRaw(name: $0.name!, categroy:$0.categroy!, unit: $0.unit ?? "", value: $0.value, updateDate: $0.updatedDate!)}
    }
    func byCategory(items: FetchedResults<Item>, viewContext: NSManagedObjectContext) async -> [Overviews] {
        // todo when name same remove dup, updateDate newer win
        var result: [String: [Overview]] = [:]
        for item in items {
            let categroy = item.categroy ?? ""
            if result[categroy] == nil {
                result[categroy] = []
            }
            let sameName = result[categroy]!.filter{$0.name == (item.name ?? "")}
            
            if sameName.isEmpty {
                // not found
                result[categroy]!.append(Overview(id: item.name ?? "", name: item.name ?? "", categroy: ICategroy(rawValue: item.categroy ?? "") ?? .UnKnow, unit: Unit(rawValue: item.unit ?? "") ?? .UnKnow, trend: .flat, value: item.value,updateDate: item.updatedDate!, raw: item))
            } else {
                var trend = OVTrend.flat
                if sameName.first!.value < item.value {
                    trend = .up
                } else {
                    trend = .down
                }
                if sameName.first!.updateDate < item.updatedDate! {
                    // when newer value update
                    result[categroy]!.removeAll{$0.name == (item.name ?? "")}
                    result[categroy]!.append(Overview(id: item.name ?? "", name: item.name ?? "", categroy: ICategroy(rawValue: item.categroy ?? "") ?? .UnKnow, unit: Unit(rawValue: item.unit ?? "") ?? .UnKnow, trend: trend, value: item.value,updateDate: item.updatedDate!, raw: item))
                }
            }
            
        }
        return await result.sorted(by: {a,b in (a.key.compare(b.key)).rawValue < 0}).asyncMap{k,v in Overviews(id: k, key: k, total: await totalOver(overs: v, viewContext: viewContext),categroy: ICategroy(rawValue: k) ?? .UnKnow, overviews: v)}
    }
    
    func totalOver(overs: [Overview], viewContext: NSManagedObjectContext) async -> Double {
        var total: Double = 0
        await overs.asyncForEach {i in
            if i.unit == model.unit {
                total = total + i.value
            } else {
                print("transfer currency by categroy \(i.categroy.rawValue)")
                let new = await CurrencySDK.transfer(origion: (i.value, i.unit), to: model.unit, viewContext: viewContext)
                total = total + new.0
            }
        }
        return total
    }
    
//    func byDate(items: FetchedResults<Item>) -> [Overviews] {
//        var result: [String: [Overview]] = [:]
//        for item in items {
//            let time = itemFormatter.string(from: item.updatedDate ?? Date.now)
//            if result[time] == nil {
//                result[time] = []
//            }
//            result[time]?.append(Overview(id: item.name ?? "", name: item.name ?? "", categroy: ICategroy(rawValue: item.categroy ?? "") ?? .UnKnow, value: item.value, raw: item))
//        }
//        return result.map{k,v in Overviews(id: k, key: k, overviews: v)}
//    }
    
    func total(items: FetchedResults<Item>, viewContext: NSManagedObjectContext) async -> Double {
//        let n = await CurrencySDK.transfer(origion: (1, Unit.USD), to: .CNY)
//        print("v: \(n.0), c: \(n.1)")
        var total: Double = 0
        var map: [String: Item] = [:]
        
        await items.asyncForEach {i in
            if map[i.name!] == nil {
                // first
                map[i.name!] = i
                if Unit(rawValue: i.unit ?? "") == model.unit {
                    total = total + i.value
                } else {
                    print("transfer currency+")
                    let new = await CurrencySDK.transfer(origion: (i.value, Unit(rawValue: i.unit ?? "") ?? .UnKnow), to: model.unit, viewContext: viewContext)
                    total = total + new.0
                }
            }
            if i.updatedDate! > map[i.name!]!.updatedDate! {
                // newer
                // todo transfer
                if Unit(rawValue: map[i.name!]!.unit!)! == model.unit {
                    total = total - map[i.name!]!.value
                } else {
                    print("transfer currency-")
                    let new = await CurrencySDK.transfer(origion: (map[i.name!]!.value, Unit(rawValue: map[i.name!]!.unit!)!),to: model.unit, viewContext: viewContext)
                    total = total - new.0
                }
                
                map[i.name!] = i
                if Unit(rawValue: i.unit!)! == model.unit {
                    total = total + i.value
                } else {
                    print("transfer currency+")
                    let new = await CurrencySDK.transfer(origion: (i.value, Unit(rawValue: i.unit!)!), to: model.unit, viewContext: viewContext)
                    total = total + new.0
                }
                
            }
            
            
        }
        
        return total
    }
}

//private let itemFormatter: DateFormatter = {
//    let formatter = DateFormatter()
//    formatter.dateStyle = .short
//    formatter.timeStyle = .medium
//    return formatter
//}()

struct Overview: Identifiable {
    var id: String
    let name: String
    let categroy: ICategroy
    let unit: Unit
    let trend: OVTrend
    let value: Double
    let updateDate: Date
    let raw: Item
    
    
    
}

enum OVTrend: String {
    case flat
    case up
    case down
}

struct OverviewWithoutRaw: Identifiable, Encodable {
    var id: UUID = UUID()
    let name: String
    let categroy: String
    let unit: String
    let value: Double
    let updateDate: Date
    
    
    
}

struct Overviews: Identifiable {
    var id: String
    
    let key: String
    let total: Double
    let categroy: ICategroy
    let overviews: [Overview]
}
