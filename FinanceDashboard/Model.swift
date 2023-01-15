//
//  Model.swift
//  FinanceDashboard
//
//  Created by 顾艳华 on 2023/1/15.
//

import Foundation

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
    case UnKnow
    
    static var all: [ICategroy] {
        ICategroy.allCases.filter {$0 != .UnKnow}
    }
}
