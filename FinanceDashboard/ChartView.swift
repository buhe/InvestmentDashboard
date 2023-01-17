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
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.createdDate, ascending: true)],
            animation: .default)
        private var items: FetchedResults<Item>
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Date")
                    .font(.custom("Avenir", size: 16))
                    .padding(.vertical, 10)
                    .border(width: 1, edges: [.bottom], color: .systemGray)
                LineChartView(data: viewModel.byDateValue(items: items), title: "Date", form: ChartForm.extraLarge, rateValue: 0) // legend is optional
                Text("Categroy")
                    .font(.custom("Avenir", size: 16))
                    .padding(.vertical, 10)
                    .border(width: 1, edges: [.bottom], color: .systemGray)
                PieChartView(data: viewModel.byCategoryValue(items: items), title: "Categroy", form: ChartForm.extraLarge) // legend is optional
            }.toolbar {
                NavigationLink {
                    SettingView(model: viewModel.model)
                } label: {
                    Image(systemName: "gear")
                }
            }
            .navigationTitle("Trend")
        }
        
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(viewModel: ChartViewModel())
    }
}
