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
    @State var lineData: [Double] = []
    @State var pieData: [Double] = []
    
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
                LineChartView(data: lineData, title: "Mouth Trend", form: ChartForm.extraLarge, rateValue: 0)
                    .onAppear{
                        Task{
                            self.lineData = await viewModel.byDateValue(items: items, viewContext: viewContext)
                        }
                    }
                // legend is optional
                Text("Categroy")
                    .font(.custom("Avenir", size: 16))
                    .padding(.vertical, 10)
                    .border(width: 1, edges: [.bottom], color: .systemGray)
                PieChartView(data: pieData.isEmpty ? viewModel.byCategroySync(items: items) : pieData, title: "Categroy", form: ChartForm.extraLarge)
                    .onAppear{
                        Task {
                            self.pieData = await viewModel.byCategoryValue(items: items, viewContext: viewContext)
                        }
                    }// legend is optional
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
