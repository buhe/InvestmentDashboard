//
//  AgeView.swift
//  FinanceDashboard
//
//  Created by 顾艳华 on 2023/1/30.
//

import SwiftUI

struct AgeView: View {
    var model: Model
    @State var age = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Form {
            TextField("Age", text: $age, onCommit: {
                presentationMode.wrappedValue.dismiss()
            })
            .onAppear{
                age = String(model.age)
            }
            .keyboardType(.numbersAndPunctuation)
            .onChange(of: age){
                a in
                if let a = Int(a) {
                    model.age = a
                }
            }
        }
    }
}

struct AgeView_Previews: PreviewProvider {
    static var previews: some View {
        AgeView(model: Model())
    }
}
