//
//  TrendViewModel.swift
//  FinanceDashboard
//
//  Created by 顾艳华 on 2023/1/20.
//

import Foundation
import CoreData
import SwiftUI

class TrendViewModel: ObservableObject {
    
  
    
    func byTrend(items: Array<Item>) -> [OverviewWithoutRaw] {
        var i = 0
        return items.map{
            i = i + 1
            return OverviewWithoutRaw(id:i, name: $0.name!, categroy:$0.categroy!, unit: $0.unit ?? "", value: $0.value, updateDate: $0.updatedDate!)
            
        }
    }
    
    func byTrendValue(items: Array<Item>) -> [Double] {
        self.byTrend(items: items).map{$0.value}
    }
}
