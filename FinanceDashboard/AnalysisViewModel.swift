//
//  AnalysisViewModel.swift
//  FinanceDashboard
//
//  Created by 顾艳华 on 2023/1/30.
//

import SwiftUI

class AnalysisViewModel: ObservableObject {
    @Published var model: Model = Model.shared
    func ratio(overviews: [Overviews]) -> Double {
        return 0
    }
    // 100 - age
    func desc(ratio: Double) -> String {
        ""
    }
}
