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
    func byDate(items: FetchedResults<Item>) {
        
    }
}

struct Chart {
    let name: String
    let categroy: ICategroy
    let value: Double
}
