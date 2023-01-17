//
//  CurrencyView.swift
//  FinanceDashboard
//
//  Created by 顾艳华 on 2023/1/17.
//

import SwiftUI

struct CurrencyView: View {
    let model: Model
    var body: some View {
        Text(model.unit.rawValue)
    }
}

struct CurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyView(model: Model(unit: .CNY))
    }
}
