//
//  OverViewModel.swift
//  FinanceDashboard
//
//  Created by 顾艳华 on 2023/1/14.
//

import Foundation
import SwiftUI

class OverViewModel: ObservableObject {
    @Published var model: Model = Model.shared
    
    func byCategory(items: FetchedResults<Item>) -> [Overviews] {
        var result: [String: [Overview]] = [:]
        for item in items {
            let categroy = item.categroy ?? ""
            if result[categroy] == nil {
                result[categroy] = []
            }
            result[categroy]?.append(Overview(id: item.name ?? "", name: item.name ?? "", categroy: ICategroy(rawValue: item.categroy ?? "") ?? .UnKnow, value: item.value, raw: item))
        }
        return result.map{k,v in Overviews(id: k, key: k, overviews: v)}
    }
    
    func byDate(items: FetchedResults<Item>) -> [Overviews] {
        var result: [String: [Overview]] = [:]
        for item in items {
            let time = itemFormatter.string(from: item.updatedDate ?? Date.now)
            if result[time] == nil {
                result[time] = []
            }
            result[time]?.append(Overview(id: item.name ?? "", name: item.name ?? "", categroy: ICategroy(rawValue: item.categroy ?? "") ?? .UnKnow, value: item.value, raw: item))
        }
        return result.map{k,v in Overviews(id: k, key: k, overviews: v)}
    }
    
    func total(items: FetchedResults<Item>) -> Double {
        var total: Double = 0
        items.forEach {i in total = total + i.value}
        return total
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct Overview: Identifiable {
    var id: String
    let name: String
    let categroy: ICategroy
    let value: Double
    let raw: Item
    
    
}

struct Overviews: Identifiable {
    var id: String
    
    let key: String
    let overviews: [Overview]
}
