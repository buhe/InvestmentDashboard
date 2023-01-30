//
//  AnalysisView.swift
//  FinanceDashboard
//
//  Created by 顾艳华 on 2023/1/30.
//

import SwiftUI
import SwiftUICharts
import Combine

struct AnalysisView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.createdDate, ascending: true)],
            animation: .default)
    private var items: FetchedResults<Item>
    @ObservedObject var analysisViewModel: AnalysisViewModel
    @ObservedObject var overViewModel: OverViewModel
    
    @State var age = ""
    @State var desc = ""
    @State var ratio: Double = 0
    @State var risk = Color.systemGray
    
    @AppStorage(wrappedValue: false, "incldueEstate") var incldueEstate: Bool
    @State private var showingIAP = false
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading){
                HStack {
                    Text("Age:")
                    TextField("Age", text: $age)
                        .keyboardType(.numbersAndPunctuation)
                        .onAppear{
                            age = String(overViewModel.model.age)
                        }
                        .onChange(of: age){
                            a in
                            if let a = Int(a) {
                                overViewModel.model.age = a
                            }
                        }
                        .frame(width: 44)
                    Text("Risk:")
                    Text("\(percentFormat(value:ratio))")
                        .foregroundColor(self.risk)
                        .onAppear{
                            Task{
                                self.ratio = await analysisViewModel.actualRatio(overviews: overViewModel.byCategory(items: items, viewContext: viewContext))
                                self.risk = analysisViewModel.risk(ratio: self.ratio)
                            }
                        }.onChange(of: self.age){
                            _ in
                            Task{
                                self.ratio = await analysisViewModel.actualRatio(overviews: overViewModel.byCategory(items: items, viewContext: viewContext))
                                self.risk = analysisViewModel.risk(ratio: self.ratio)
                            }
                        }
                    
                }
                .font(.title)
                .fontWeight(.bold)
                
                Divider()
                
                Text("Low Risk")
                    .font(.title2)
                Text("By nature, with low-risk investing, there is less at stake—either in terms of the amount of invested or the significance of the investment to the portfolio. There is also less to gain—either in terms of the potential return or the potential benefit bigger term."
                )
                .lineLimit(20)
                Text("High Risk")
                    .font(.title2)
                    .padding(.top)
                Text("A high-risk investment is one for which there is either a large percentage chance of loss of capital or under-performance—or a relatively high chance of a devastating loss. The first of these is intuitive, if subjective: If you were told there’s a 50/50 chance that your investment will earn your expected return, you may find that quite risky. If you were told that there is a 95% percent chance that the investment will not earn your expected return, almost everybody will agree that that is risky.")
                    .lineLimit(20)
                PieChartView(data: [1 - ratio, ratio], title: "Risk", style: colorScheme == .light ? ChartStyle(backgroundColor: Color.white, accentColor: Colors.BorderBlue, secondGradientColor: Colors.BorderBlue, textColor: Color.black, legendTextColor: Color.black, dropShadowColor: .gray) : ChartStyle(backgroundColor: Color.gray, accentColor: Colors.BorderBlue, secondGradientColor: Colors.BorderBlue, textColor: Color.white, legendTextColor: Color.white, dropShadowColor: .gray), form: ChartForm.extraLarge)
                    .padding(.top)
                Text("Summary")
                    .font(.title2)
                    .padding(.top)
                Text(self.desc)
                    .onAppear{
                        Task{
                            self.desc = await analysisViewModel.desc(ratio: analysisViewModel.actualRatio(overviews: overViewModel.byCategory(items: items, viewContext: viewContext)))
                        }
                    }
                    .lineLimit(20)
                Spacer()
            }
            .padding()
            HStack{
                Image(systemName: "house")
                Toggle("Include Estate", isOn: $incldueEstate)
                    .onReceive(Just(incldueEstate)) {
                        value in
                        // true -> fasle
                        if value {
                            //                                print("receive: \(value)")
                            if !overViewModel.model.iap {
                                incldueEstate.toggle()
                                showingIAP = true
                            }
                        }
                        
                    }
            }
            .padding(.horizontal)
        }
        .sheet(isPresented: $showingIAP){
            ProView{
                showingIAP = false
            }
        }
//        .backgroundFill(.red)
        
        
    }
}

struct AnalysisView_Previews: PreviewProvider {
    static var previews: some View {
        AnalysisView(analysisViewModel: AnalysisViewModel(), overViewModel: OverViewModel())
    }
}
