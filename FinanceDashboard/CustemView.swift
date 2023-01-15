//
//  CustemView.swift
//  FinanceDashboard
//
//  Created by 顾艳华 on 2023/1/15.
//

import SwiftUI

struct BigImage: View {
    let system: String
    let categroy: ICategroy
    var body: some View {
        VStack {
            Image(systemName: system)
                .resizable()
                .frame(width: 50, height: 50)
            Text(categroy.rawValue)
        }
    }
}
