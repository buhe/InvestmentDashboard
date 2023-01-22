//
//  ProView.swift
//  FinanceDashboard
//
//  Created by 顾艳华 on 2023/1/22.
//

import SwiftUI

struct ProView: View {
    let title: String
    let desc: String
    
//    @ObservedObject var iapManager = IAPManager.shared
    
    
    var body: some View {
        VStack(alignment: .leading){
            Text(title)
                .font(.title)
                .padding(.vertical)
            Text(desc)
                .padding(.vertical)
            // !iap.p.isEmpty
            Button{
                IAPManager.shared.buy(product: IAPManager.shared.products.first!)
            }label: {
                Text("Un Lock")
            }
            .disabled(IAPManager.shared.products.isEmpty)
            Spacer()
        }
        .padding()
        .frame(minWidth: 400)
//        .onAppear {
//            self.iapManager.getProducts()
//        }
    }
}

struct ProView_Previews: PreviewProvider {
    static var previews: some View {
        ProView(title: "title", desc: """
                                        -1111111111111111111111111111111111111111111111
                                        - 2222
                                    """
        )
    }
}
