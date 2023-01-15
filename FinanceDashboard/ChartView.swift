//
//  ChartView.swift
//  FinanceDashboard
//
//  Created by 顾艳华 on 2023/1/13.
//

import SwiftUI
import SwiftUICharts

struct ChartView: View {
    @ObservedObject var viewModel: ChartViewModel
    var demoData: [Double] = [8, 2, 4, 6, 12, 9, 2]
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Date")
                    .font(.custom("Avenir", size: 16))
                    .padding(.vertical, 10)
                    .border(width: 1, edges: [.bottom], color: .systemGray)
                LineChart()
                    .data(demoData)
                    .chartStyle(ChartStyle(backgroundColor: .white,
                                                foregroundColor: ColorGradient(.blue, .purple)))
                    .padding()
                Text("Categroy")
                    .font(.custom("Avenir", size: 16))
                    .padding(.vertical, 10)
                    .border(width: 1, edges: [.bottom], color: .systemGray)
                PieChart()
                    .data(demoData)
                    .chartStyle(ChartStyle(backgroundColor: .white,
                                                foregroundColor: ColorGradient(.blue, .purple)))
                    .padding()
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
