//
//  OverView.swift
//  FinanceDashboard
//
//  Created by 顾艳华 on 2023/1/13.
//

import SwiftUI

struct OverView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
            sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
            animation: .default)
        private var items: FetchedResults<Item>
    var body: some View {
        NavigationStack {
            Form {
                List {
                    ForEach(items) { item in
                        
                        Text(item.timestamp!.debugDescription)
                        
                    }
                }
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

struct OverView_Previews: PreviewProvider {
    static var previews: some View {
        OverView()
    }
}
