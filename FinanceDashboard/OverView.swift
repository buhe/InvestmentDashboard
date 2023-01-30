//
//  OverView.swift
//  FinanceDashboard
//
//  Created by 顾艳华 on 2023/1/13.
//

import SwiftUI
import SwiftUIX

struct OverView: View {
//    @State var search = ""
    @State var tabIndex = 0
    var tabData: MainTabBarData
    
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var viewModel: OverViewModel
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.createdDate, ascending: true)],
            animation: .default)
        private var items: FetchedResults<Item>
    
    @State var total: Double = 0
    @State var overviews: [Overviews] = []
    var body: some View {
        VStack {
            NavigationStack {
//                SearchBar(text: $search).padding(.horizontal)
                    
                OverviewTabBar(tabIndex: $tabIndex).padding(.horizontal, 26)
                    .navigationTitle( currencyToFlag(currency: viewModel.model.unit.rawValue) + currencyFormatter.string(from: total as NSNumber)!)
                    .onAppear{
                        Task{
                            self.total = await viewModel.total(items: items, viewContext: viewContext)
                        }
                    }
                    .onChange(of: String(data: try! JSONEncoder().encode(viewModel.byChangeMonitor(items: items)), encoding: .utf8)!){
                        i in
                        print(i)
                        Task{
                            self.total = await viewModel.total(items: items, viewContext: viewContext)
                            self.overviews = await viewModel.byCategory(items: items, viewContext: viewContext)
                        }
                    }
//                switch tabIndex {
//                case 0:
                    List {
                        ForEach(overviews) { overviews in
                            CardView(item: overviews)
                                .environment(\.managedObjectContext, viewContext)
                        }
                        
                        .listRowSeparator(.hidden)
                    }
                    .onAppear{
                        Task{
                            self.overviews = await viewModel.byCategory(items: items, viewContext: viewContext)
                        }
                    }
                    .listStyle(PlainListStyle())
//                    .toolbar {
//                        NavigationLink {
//                            SettingView(model: viewModel.model)
//                                .environment(\.managedObjectContext, viewContext)
//                        } label: {
//                            Image(systemName: "gear")
//                        }
//                    }
//                case 1:
//                    List {
//                        ForEach(viewModel.byDate(items: items)) { overviews2 in
//                            CardView(item: overviews2)
//                        }
//                        .listRowSeparator(.hidden)
//                    }
//                    .listStyle(PlainListStyle())
//                    .toolbar {
//                        NavigationLink {
//                            SettingView(model: viewModel.model)
//                        } label: {
//                            Image(systemName: "gear")
//                        }
//                    }
//                default: EmptyView()
//                }
                
            }
        }
    }
}

//struct OverView_Previews: PreviewProvider {
//    static var previews: some View {
//        OverView(viewModel: OverViewModel())
//    }
//}
