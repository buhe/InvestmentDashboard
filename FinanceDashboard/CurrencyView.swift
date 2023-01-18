//
//  CurrencyView.swift
//  FinanceDashboard
//
//  Created by 顾艳华 on 2023/1/17.
//

import SwiftUI

struct CurrencyView: View {
    let model: Model
    @State var currency: String = Unit.USD.rawValue
    var body: some View {
        NavigationStack {
            Picker("Currency", selection: $currency){
                ForEach(Unit.allCases, id: \.self){
                    Text($0.rawValue)
                }
                
            }
        }
    }
}

struct CurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyView(model: Model(unit: .CNY))
    }
}
