//
//  SettingView.swift
//  FinanceDashboard
//
//  Created by 顾艳华 on 2023/1/14.
//

import SwiftUI
import Combine

struct SettingView: View {
    let model: Model
    @AppStorage(wrappedValue: false, "face") var faceIdEnable: Bool
    
    @Environment(\.managedObjectContext) private var viewContext
    var body: some View {
        NavigationStack {
            Form{
                Section(){
                    Button{
                        #if os(iOS)
                        if let url = URL(string: "https://github.com/buhe/InvestmentDashboard/issues") {
                            UIApplication.shared.open(url)
                        }
                        #endif
                    } label: {
                        
                        Text("Feedback")
                        
                    }.buttonStyle(PlainButtonStyle())
                   
                    ExportView()
                        .environment(\.managedObjectContext, viewContext)
                    
                    NavigationLink {
                        CurrencyView(model: model)
                    } label: {
                        Text("Currency")
                    }
                    Toggle("Face ID", isOn: $faceIdEnable)
                    HStack{
                        Text("Version")
                        Spacer()
                        Text("1")
                    }
                    HStack{
                        Text("License")
                        Spacer()
                        Text("GPLv3")
                    }
                }
                
                
            }
        }
    }
}

//struct SettingView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingView(model: Model())
//    }
//}
