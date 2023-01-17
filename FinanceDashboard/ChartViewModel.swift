//
//  ChartViewModel.swift
//  FinanceDashboard
//
//  Created by 顾艳华 on 2023/1/14.
//

import Foundation
import SwiftUI

class ChartViewModel: ObservableObject {
    func byCategory(items: FetchedResults<Item>) -> [String: [Chart]] {
        var result: [String: [Chart]] = [:]
        for item in items {
            let categroy = item.categroy ?? ""
            if result[categroy] == nil {
                result[categroy] = []
            }
            result[categroy]?.append(Chart(name: item.name ?? "", categroy: ICategroy(rawValue: item.categroy ?? "") ?? .UnKnow, value: item.value ))
        }
        return result
    }
    func byCategoryLabel(items: FetchedResults<Item>) -> [String] {
        self.byCategory(items: items)
            .map{
                k,v in
                k
            }
    }
    func byCategoryValue(items: FetchedResults<Item>) -> [Double] {
        self.byCategory(items: items)
            .map{
                k,v in
                var total: Double = 0
                v.forEach{total = total + $0.value}
                print(total)
                return total
                
            }
    }
    func byDate(items: FetchedResults<Item>) -> Array<(key: String, value: Array<Chart>)> {
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
            result[time]?.append(Chart(name: item.name ?? "", categroy: ICategroy(rawValue: item.categroy ?? "") ?? .UnKnow, value: item.value ))
        }
        if result.count < 10 {
            let now = Date.now
            for i in 1...(10 - result.count) {
                let previousMonth = Calendar.current.date(byAdding: .month, value: -i, to: minTime)!
                let time = itemFormatter.string(from: previousMonth)
                result[time] = [Chart(name: "Empty", categroy: .UnKnow, value: 0)]
            }
            
        }
        return result.sorted(by: {a,b in (a.key.compare(b.key)).rawValue < 0})
    }
    
    func byDateValue(items: FetchedResults<Item>) -> [Double] {
        let dates = self.byDate(items: items).map {
            k,v in
            var total: Double = 0
            v.forEach{total = total + $0.value}
            print("Date: \(k) \(total)")
            return total
        }
        // todo
        // 1 by time
        // 2 corrot time
        return dates.sorted{a,b in a < b}
//        return dates
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM"
//    formatter.timeStyle = .none
    return formatter
}()

struct Chart {
    let name: String
    let categroy: ICategroy
    let value: Double
}
