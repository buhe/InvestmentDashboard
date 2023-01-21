//
//  Model.swift
//  FinanceDashboard
//
//  Created by 顾艳华 on 2023/1/15.
//

import Foundation
import SwiftUI

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
    
    static let shared: Model = Model()
}

enum Unit: String, CaseIterable {
    case CNY
    case USD
    case UnKnow
}
