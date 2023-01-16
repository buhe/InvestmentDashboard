//
//  CustemView.swift
//  FinanceDashboard
//
//  Created by 顾艳华 on 2023/1/15.
//

import SwiftUI

struct BigImage: View {
    let systemName: String
    let categroy: ICategroy
    var body: some View {
        VStack {
            Image(systemName: systemName)
                .resizable()
                .frame(width: 50, height: 50)
            Text(categroy.rawValue)
        }
    }
}
