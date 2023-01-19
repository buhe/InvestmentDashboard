//
//  ExportView.swift
//  FinanceDashboard
//
//  Created by 顾艳华 on 2023/1/19.
//

import SwiftUI

struct ExportView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.createdDate, ascending: true)],
            animation: .default)
        private var items: FetchedResults<Item>
    var body: some View {
        List {
            Button{
                CSV().export(items: items)
            }label: {
                Text("CSV")
            }
        }
    }
}

struct ExportView_Previews: PreviewProvider {
    static var previews: some View {
        ExportView()
    }
}
