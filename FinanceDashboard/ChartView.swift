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
             
//                    .frame(width: 400, height: 200)
                    LineChartWrapper(title: "Mouth Trend", lineData: lineData)
                        .onAppear{
                            Task{
                                self.lineData = await viewModel.byDateValue(items: items, viewContext: viewContext)
                            }
                        }
                HStack{
                    ForEach(viewModel.byDateLabel(items: items), id: \.self){
                        time in
                        Text(time)
                            .font(.system(size: 6))
                    }
                }
                .padding(.bottom)
                // legend is optional
//                Text("Categroy")
//                    .font(.custom("Avenir", size: 16))
//                    .padding(.vertical, 10)
//                    .border(width: 1, edges: [.bottom], color: .systemGray)
                ZStack{
                    PieChartView(data: pieData.isEmpty ? viewModel.byCategroySync(items: items) : pieData, title: "Categroy", style: colorScheme == .light ? ChartStyle(backgroundColor: Color.white, accentColor: Colors.OrangeStart, secondGradientColor: Colors.OrangeEnd, textColor: Color.black, legendTextColor: Color.black, dropShadowColor: .gray) : ChartStyle(backgroundColor: Color.gray, accentColor: Colors.OrangeStart, secondGradientColor: Colors.OrangeEnd, textColor: Color.white, legendTextColor: Color.white, dropShadowColor: .gray), form: ChartForm.extraLarge)
                        .onAppear{
                            Task {
                                self.pieData = await viewModel.byCategoryValue(items: items, viewContext: viewContext)
                            }
                        }
                        
                    GeometryReader{
                        rect in
                        
                        Grid {
                            GridRow {
                                Text("")
                                Text("")
                                Text("")
                            }
                            .frame(minWidth: rect.size.width / 3, minHeight: rect.size.height / 4)
                            GridRow {
                                CategroyLabel(labels: viewModel.byCategoryLabel(items: items))
                            }
                            .frame(minWidth: rect.size.width / 3, minHeight: rect.size.height / 2)
                            GridRow {
                                Text("")
                                Text("")
                                Text("")
                            }
                            .frame(minWidth: rect.size.width / 3, minHeight: rect.size.height / 4)
                            
                            
                        }
                        
                    }
                    .frame(width: 400, height: 200)
                   
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

struct CategroyLabel: View {
    let labels: [String]
    var body: some View {
        if labels.count > 5 {
            VStack{
                ForEach(Array(labels[0 ..< 5]), id: \.self){
                    t in
                    Text(t)
                }
            }
            .font(.caption)
            .padding()
            Text("")
            VStack{
                ForEach(Array(labels[5 ..< labels.count]), id: \.self){
                    t in
                    Text(t)
                }
            }
            .font(.caption)
            .padding()
        } else {
            VStack{
                ForEach(labels, id: \.self){
                    t in
                    Text(t)
                }
            }
            .font(.caption)
            .padding()
            Text("")
            Text("")
        }
        
    }
}
