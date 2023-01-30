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
    @Environment(\.colorScheme) private var colorScheme
    
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
//                Text("Date")
//                    .font(.custom("Avenir", size: 16))
//                    .padding(.vertical, 10)
//                    .border(width: 1, edges: [.bottom], color: .systemGray)
                LineChartWrapper(title: "Mouth Trend", lineData: lineData)
                    .onAppear{
                        Task{
                            self.lineData = await viewModel.byDateValue(items: items, viewContext: viewContext)
                        }
                    }
                // legend is optional
//                Text("Categroy")
//                    .font(.custom("Avenir", size: 16))
//                    .padding(.vertical, 10)
//                    .border(width: 1, edges: [.bottom], color: .systemGray)
                PieChartView(data: pieData.isEmpty ? viewModel.byCategroySync(items: items) : pieData, title: "Categroy", style: colorScheme == .light ? ChartStyle(backgroundColor: Color.white, accentColor: Colors.OrangeStart, secondGradientColor: Colors.OrangeEnd, textColor: Color.black, legendTextColor: Color.black, dropShadowColor: .gray) : ChartStyle(backgroundColor: Color.gray, accentColor: Colors.OrangeStart, secondGradientColor: Colors.OrangeEnd, textColor: Color.white, legendTextColor: Color.white, dropShadowColor: .gray), form: ChartForm.extraLarge)
                    .onAppear{
                        Task {
                            self.pieData = await viewModel.byCategoryValue(items: items, viewContext: viewContext)
                        }
                    }
                    .padding()
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
