//
//  OverView.swift
//  FinanceDashboard
//
//  Created by 顾艳华 on 2023/1/13.
//

import SwiftUI

struct OverView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var viewModel: OverViewModel
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.createdDate, ascending: true)],
            animation: .default)
        private var items: FetchedResults<Item>
    var body: some View {
        NavigationStack {
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
        }
        
    }
}

struct OverView_Previews: PreviewProvider {
    static var previews: some View {
        OverView(viewModel: OverViewModel())
    }
}
