//
//  EditItem.swift
//  FinanceDashboard
//
//  Created by 顾艳华 on 2023/1/16.
//

import SwiftUI

struct EditItem: View {
    let overview: Overview
    
    @State private var name = ""
    @State private var value = ""
    // let close: () -> Void
    
    @FocusState private var keyFocused: Bool
    
    var body: some View {
        NavigationStack {
            Form {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]){
                    ForEach(ICategroy.all){ c in
                        VStack {
                            switch c {
                            case .Cash:
                                BigImage(system: "dollarsign.circle", categroy: .Cash)
                            case .Bond:
                                BigImage(system: "b.circle", categroy: .Bond)
                            case .Debt:
                                BigImage(system: "creditcard", categroy: .Debt)
                            case .Estate:
                                BigImage(system: "house", categroy: .Estate)
                            case .Fund:
                                BigImage(system: "gauge.high", categroy: .Fund)
                            case .Futures:
                                BigImage(system: "carrot", categroy: .Futures)
                            case .Option:
                                BigImage(system: "target", categroy: .Option)
                            case .Stock:
                                BigImage(system: "waveform.path.ecg", categroy: .Stock)
                                
                            default:
                                Image(systemName: "dollarsign.circle")
                            }
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
//                        .onTapGesture {
//                            keyFocused = true
//                        }
                     
                    }
                }
                .padding()
                TextField("Enter name", text: $name)
                    .focused($keyFocused)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            HStack {
                              
                                TextField("Value:", text: $value).keyboardType(.numberPad)
                                Button{} label: {
                                    Text("Done")
                                }
                            }
                            
                        }
                    }
            }
            .onAppear {
                keyFocused = true
                name = overview.name
//                value = overview.
            }
            
        }
    }
}
//
//struct EditItem_Previews: PreviewProvider {
//    static var previews: some View {
//        EditItem()
//    }
//}
