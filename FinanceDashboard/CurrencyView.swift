//
//  CurrencyView.swift
//  FinanceDashboard
//
//  Created by 顾艳华 on 2023/1/17.
//

import SwiftUI

struct CurrencyView: View {
    var model: Model
    @State var currency = Unit.USD
    var body: some View {
        NavigationStack {
            Picker("Currency", selection: $currency){
                ForEach(Unit.allCases, id: \.self){
                    Text($0.rawValue)
                }
                
            }.onChange(of: currency){
                c in
                model.unit = c
            }.onAppear{
                currency = model.unit
            }
        }
    }
}

struct CurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyView(model: Model())
    }
}
