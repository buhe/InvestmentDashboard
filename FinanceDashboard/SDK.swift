//
//  SDK.swift
//  FinanceDashboard
//
//  Created by 顾艳华 on 2023/1/18.
//

import Foundation

struct CurrencySDK {
    
    static func transfer(origion: (Double, Unit) ) async -> (Double ,Unit) {
        var result: (Double, Unit) = (0, .UnKnow)
        switch origion.1 {
        case .USD:
            result.1 = .CNY
            result.0 = origion.0 * 7
        default: break
        }
        return result
    }
}
