//
//  ProView.swift
//  FinanceDashboard
//
//  Created by 顾艳华 on 2023/1/22.
//

import SwiftUI
import SwiftUIX

struct ProView: View {
    let title: String = "Pro"
  
    @ObservedObject var viewModel: IAPViewModel = IAPViewModel.shared
//    @ObservedObject var iapManager = IAPManager.shared
    
    let close: () -> Void
    
    
    var body: some View {
        if viewModel.loading {
            ActivityIndicator()
        } else {
            VStack(alignment: .leading){
                Text(title)
                    .font(.title)
                ProCardView(text: "📔 Export PDF file to save.")
                    
                ProCardView(text: "🔑 Use Face ID to protect your asset data.")
                    
                ProCardView(text: "💼 Include Estate assets.")
                    
                ProCardView(text: "🙇 Support us.")
                    
                // !iap.p.isEmpty
                HStack{
                    Button{
                        IAPViewModel.shared.loading = true
                        IAPManager.shared.buy(product: IAPManager.shared.products.first!)
                        
                    }label: {
                        Text("UnLock")
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(IAPManager.shared.products.isEmpty)
                    Button{
                        IAPViewModel.shared.loading = true
                        IAPManager.shared.restore()
                    }label: {
                        Text("Restore")
                    }
                }
                Spacer()
            }
            
            .padding()
            .onAppear{
                if Model.shared.iap {
                    close()
                }
            }
        }

//        .onAppear {
//            self.iapManager.getProducts()
//        }
    }
}

struct ProView_Previews: PreviewProvider {
    static var previews: some View {
        ProView{}
    }
}

struct ProCardView: View {
    @Environment(\.colorScheme) private var colorScheme

    @State var text: String
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(colorScheme == .light ? .white : .gray)
                .shadow(radius: 10)
            Text(text)
                .padding(.horizontal)
        }
        .frame(maxHeight: 50)
        
            
            
        }
}
