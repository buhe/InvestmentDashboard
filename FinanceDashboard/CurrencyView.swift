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
    
//    init(model: Model) {
//        self.model = model
//        self.selection = model.unit.rawValue
//    }
    var body: some View {
        NavigationView {
            VStack {
                List(Unit.allCases.map{$0.rawValue}, id: \.self, selection: $selection) { c in
                    switch Unit(rawValue: c)! {
                    case .UnKnow: EmptyView()
                    default: Text(c)
                    }
                }
//                Text("\(selection ?? "..")")
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
