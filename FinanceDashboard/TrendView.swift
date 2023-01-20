//
//  TrendView.swift
//  FinanceDashboard
//
//  Created by 顾艳华 on 2023/1/20.
//

import SwiftUI
import CoreData
import SwiftUICharts

struct TrendView: View {
//    @EnvironmentObject var name: StringWrapper
    let name: String
    private var viewContext: NSManagedObjectContext
    @ObservedObject var viewModel: TrendViewModel
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Item.updatedDate, ascending: true)],
//        predicate: NSPredicate(format: "name == %@", name),
//            animation: .default)
        private var items: Array<Item>
    
    init(name: String, viewContext: NSManagedObjectContext,viewModel: TrendViewModel) {
        self.name = name
        self.viewContext = viewContext
        self.viewModel = viewModel
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        request.predicate = NSPredicate(format: "name == %@", name)
        self.items = try! viewContext.fetch(request) as! Array<Item>
    }
    
    var body: some View {
        Text("Chart")
            .font(.custom("Avenir", size: 16))
            .padding(.vertical, 10)
            .border(width: 1, edges: [.bottom], color: .systemGray)
        LineChartView(data: viewModel.byTrendValue(items: items), title: "Mouth Trend", form: ChartForm.extraLarge, rateValue: 0)
        Text("Datas")
            .font(.custom("Avenir", size: 16))
            .padding(.vertical, 10)
            .border(width: 1, edges: [.bottom], color: .systemGray)
        List {
            ForEach(viewModel.byTrend(items: items)) {
                i in
                HStack {
                    Text(i.name)
                    Spacer()
                    Text(itemFormatter.string(from:i.updateDate))
                    Text(doubleFormat(value: i.value))
                    Text(i.unit)
                }
                
            }
        }
    }
}

//struct TrendView_Previews: PreviewProvider {
//    static var previews: some View {
//        TrendView()
//    }
//}
