//
//  AnalysisView.swift
//  FinanceDashboard
//
//  Created by 顾艳华 on 2023/1/30.
//

import SwiftUI

struct AnalysisView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.createdDate, ascending: true)],
            animation: .default)
    private var items: FetchedResults<Item>
    @ObservedObject var analysisViewModel: AnalysisViewModel
    @ObservedObject var overViewModel: OverViewModel
    var body: some View {
        VStack(alignment: .leading){
            HStack {
                Text("Age:")
                Text(String(overViewModel.model.age))
                Text("Ratio:")
                Text(doubleFormat(value: 40))
                    
            }
            .font(.title)
            
            Divider()
            Text("11")
                .font(.title2)
            Text("1234"
                )
            Text("22")
                .font(.title2)
            Text("111111111111111111111111111111111111111111111111111111111111")
            Text("Summary")
                .font(.title2)
            Text("111111111111111111111111111111111111111111111111111111111111")
            Spacer()
        }
        .padding()
//        .backgroundFill(.red)
        
        
    }
}

struct AnalysisView_Previews: PreviewProvider {
    static var previews: some View {
        AnalysisView(analysisViewModel: AnalysisViewModel(), overViewModel: OverViewModel())
    }
}
