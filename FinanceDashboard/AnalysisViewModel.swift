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
        let high = max(100 - model.age, 0)
        let theoryRatio: Double = Double(high) / 100
        let red = (ratio - theoryRatio) > 20
        let yellow = (ratio - theoryRatio) > 0 && (ratio - theoryRatio) <= 20
//        let green = (ratio - theoryRatio) <= 0
        if red {
            return "Your high-risk investments are too high for your age (\(model.age)), consider adding some low-risk investments."
        } else {
            if yellow {
                return "Your high-risk investment ratio is a bit high for your age (\(model.age)), but the excess ratio is less than 20%."
            } else {
                return "Your high and low risk investments are proportionate to your age (\(model.age))."
            }
        }
        
    }
}
