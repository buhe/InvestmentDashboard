//
//  ChartView.swift
//  FinanceDashboard
//
//  Created by 顾艳华 on 2023/1/13.
//

import SwiftUI

struct ChartView: View {
    @ObservedObject var viewModel: ChartViewModel
    
    var body: some View {
        NavigationStack {
            Form {
                
            }.toolbar {
                NavigationLink {
                    SettingView()
                } label: {
                    Image(systemName: "gear")
                }
            }
        }
        
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(viewModel: ChartViewModel())
    }
}
