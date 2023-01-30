//
//  AnalysisViewModel.swift
//  FinanceDashboard
//
//  Created by 顾艳华 on 2023/1/30.
//

import SwiftUI

class AnalysisViewModel: ObservableObject {
    @Published var model: Model = Model.shared
    func actualRatio(overviews: [Overviews]) -> Double {
        var base: Double = 0
        var high: Double = 0
        for o in overviews {
            switch o.categroy {
            case .Stock:
                base = base + o.total
                high = high + o.total
            case .Cash:
                base = base + o.total
            case .Savings:
                base = base + o.total
            case .Bond:
                base = base + o.total
            case .Debt: break
            case .Estate:
                if model.incldueEstate {
                    base = base + o.total
                }
                break
            case .Fund:
                base = base + o.total
                high = high + o.total
            case .Futures:
                base = base + o.total
                high = high + o.total
            case .Option:
                base = base + o.total
                high = high + o.total
            case .UnKnow: break
            }
        }
        return high / base
    }
    // 100 - age
    func desc(ratio: Double) -> String {
        let risk = riskAl(ratio: ratio)
        if risk == .high {
            return "Your high-risk investments are too high for your age (\(model.age)), consider adding some low-risk investments."
        } else {
            if risk == .warning {
                return "Your high-risk investment ratio is a bit high for your age (\(model.age)), but the excess ratio is less than 20%."
            } else {
                return "Your high and low risk investments are proportionate to your age (\(model.age))."
            }
        }
        
    }
    
    func risk(ratio: Double) -> Color {
        let risk = riskAl(ratio: ratio)
        if risk == .high {
            return .red
        } else {
            if risk == .warning {
                return .yellow
            } else {
                return .green
            }
        }
    }
    
    func riskAl(ratio: Double) -> Risk {
        let high = max(100 - model.age, 0)
        let theoryRatio: Double = Double(high) / 100
        let red = (ratio - theoryRatio) > 0.2
        let yellow = (ratio - theoryRatio) > 0 && (ratio - theoryRatio) <= 0.2
        return red ? Risk.high : yellow ? Risk.warning : Risk.low
    }
}

enum Risk {
    case high
    case warning
    case low
}
