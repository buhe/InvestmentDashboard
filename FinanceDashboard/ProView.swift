//
//  ProView.swift
//  FinanceDashboard
//
//  Created by 顾艳华 on 2023/1/22.
//

import SwiftUI

struct ProView: View {
    let title: String = "Pro"
    let desc: String = """
                        📔 Export PDF file to save.
                        🔑 Use Face ID to protect your asset data.
                        🙇 Support us.
                        """
    
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
                Text("UnLock")
            }
            .buttonStyle(.borderedProminent)
            .disabled(IAPManager.shared.products.isEmpty)
            Spacer()
        }
        
        .padding()

//        .onAppear {
//            self.iapManager.getProducts()
//        }
    }
}

struct ProView_Previews: PreviewProvider {
    static var previews: some View {
        ProView()
    }
}
