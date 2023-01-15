//
//  OverView.swift
//  FinanceDashboard
//
//  Created by 顾艳华 on 2023/1/13.
//

import SwiftUI
import SwiftUIX

struct OverView: View {
    @State var search = ""
    @State var tabIndex = 0
    
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var viewModel: OverViewModel
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.createdDate, ascending: true)],
            animation: .default)
        private var items: FetchedResults<Item>
    var body: some View {
        VStack {
            NavigationStack {
                SearchBar(text: $search).padding(.horizontal)
                OverviewTabBar(tabIndex: $tabIndex).padding(.horizontal, 26)
                switch tabIndex {
                case 0:
                    List {
                        ForEach(viewModel.byCategory(items: items)) { overviews in
                            CardView(item: overviews)
                        }
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(PlainListStyle())
                    .toolbar {
                        NavigationLink {
                            SettingView()
                        } label: {
                            Image(systemName: "gear")
                        }
                    }
                case 1:
                    List {
                        ForEach(viewModel.byCategory(items: items)) { overviews in
                            CardView(item: overviews)
                        }
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(PlainListStyle())
                    .toolbar {
                        NavigationLink {
                            SettingView()
                        } label: {
                            Image(systemName: "gear")
                        }
                    }
                default: EmptyView()
                }
                
            }
        }
    }
}

struct OverView_Previews: PreviewProvider {
    static var previews: some View {
        OverView(viewModel: OverViewModel())
    }
}
