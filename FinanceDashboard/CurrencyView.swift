//
//  CurrencyView.swift
//  FinanceDashboard
//
//  Created by 顾艳华 on 2023/1/17.
//

import SwiftUI

struct CurrencyView: View {
    var model: Model
    @State private var selection: String?
    //selection must be optional
    
//    init(model: Model) {
//        self.model = model
//        self.selection = model.unit.rawValue
//    }
    var body: some View {
        NavigationStack {
            List(Unit.allCases.map{$0.rawValue}, id: \.self, selection: $selection) { c in
                switch Unit(rawValue: c)! {
                    case .UnKnow: EmptyView()
                    default:
                    HStack{
                        Text(currencyToFlag(currency: c))
                        Text(c)
                    }
                }
            }.onChange(of: selection ?? ""){
                c in
                model.unit = Unit(rawValue: c)!
            }
            .navigationTitle("Currencies")
        }
    }
}

struct CurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyView(model: Model())
    }
}
