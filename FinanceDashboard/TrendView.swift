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
        NavigationStack{
            LineChartWrapper(title: "Trend", lineData: viewModel.byTrendValue(items: items))
                .toolbar{
                    EditButton()
                }
            //        LineChartView(data: viewModel.byTrendValue(items: items), title: "Trend", form: ChartForm.extraLarge, rateValue: 0)
            Text("Details")
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
                    
                }.onDelete {
                    deleteItems(offsets: $0)
                }
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
            withAnimation {
                offsets.map { items[$0] }.forEach(viewContext.delete)
    
                do {
                    try viewContext.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
            }
        }
}


//struct TrendView_Previews: PreviewProvider {
//    static var previews: some View {
//        TrendView()
//    }
//}
