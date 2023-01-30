//
//  ContentView.swift
//  FinanceDashboard
//
//  Created by 顾艳华 on 2023/1/1.
//

import SwiftUI
import CoreData
import Combine
import LocalAuthentication

struct ContentView: View {
    @State private var isUnlocked = false
    
    @Environment(\.managedObjectContext) private var viewContext
//
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
//        animation: .default)
//    private var items: FetchedResults<Item>
    @ObservedObject var overViewModel: OverViewModel
    @ObservedObject var chartViewModel: ChartViewModel
    @ObservedObject var analysisViewModel: AnalysisViewModel
    @ObservedObject private var tabData = MainTabBarData(initialIndex: 1, customItemIndex: 3)


        var body: some View {
            VStack {
                if isUnlocked {
                    TabView(selection: $tabData.itemSelected) {
                        OverView(tabData: tabData, viewModel: overViewModel)
                            .environment(\.managedObjectContext, viewContext)
                            .tabItem {
                                VStack {
                                    Image(systemName: "note.text")
                                    Text("Overview")
                                }

                            }.tag(1)
                        AnalysisView(analysisViewModel: analysisViewModel, overViewModel: overViewModel)
                            .environment(\.managedObjectContext, viewContext)
                            .tabItem {
                                VStack {
                                    Image(systemName: "waveform.and.magnifyingglass")
                                    Text("Analysis")
                                }
                        }.tag(2)
                        Text("Add")
                            .tabItem {
                                Image("plus.circle", tintColor: .systemBlue)
                            }
                            .tag(3)

                        ChartView(viewModel: chartViewModel)
                            .environment(\.managedObjectContext, viewContext)
                            .tabItem {
                                VStack {
                                    Image(systemName: "chart.pie")
                                    Text("Chart")
                                }
                        }.tag(4)
                        
                        SettingView(model: chartViewModel.model)
                            .environment(\.managedObjectContext, viewContext)
                            .tabItem {
                                VStack {
                                    Image(systemName: "gear")
                                    Text("Settings")
                                }
                        }.tag(5)
                        
                    }.sheet(isPresented: $tabData.isCustomItemSelected) {
                        EditItem(overview: nil, currency: Model.shared.unit) {
                            tabData.itemSelected = tabData.previousItem
                            tabData.isCustomItemSelected = false
                        }
                        .environment(\.managedObjectContext, viewContext)
                    }
                } else {
                    Button{
                        authenticate()
                    }label: {
                        Image(systemName: "faceid")
                            .resizable()
                            .frame(width: 100, height: 100)
                    }
                }
            }
            .onAppear(perform: authenticate)
            



        }

//    private func addItem() {
//        withAnimation {
//            let newItem = Item(context: viewContext)
//            newItem.timestamp = Date()
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
//
//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            offsets.map { items[$0] }.forEach(viewContext.delete)
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
    
    func authenticate() {
        if overViewModel.model.faceIdEnable {
            let context = LAContext()
            var error: NSError?
            
            // check whether biometric authentication is possible
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                // it's possible, so go ahead and use it
                let reason = "We need to unlock your data."
                
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                    // authentication has now completed
                    if success {
                        // authenticated successfully
                        isUnlocked = true
                    } else {
                        // there was a problem
                    }
                }
            } else {
                // no biometrics
                isUnlocked = true
            }
        } else {
            isUnlocked = true
        }
    }
}

final class MainTabBarData: ObservableObject {

    /// This is the index of the item that fires a custom action
    let customActiontemindex: Int

    let objectWillChange = PassthroughSubject<MainTabBarData, Never>()

    var previousItem: Int

    var itemSelected: Int {
        didSet {
            if itemSelected == customActiontemindex {
                previousItem = oldValue
                itemSelected = oldValue
                isCustomItemSelected = true
            }
            objectWillChange.send(self)
        }
    }

    func reset() {
        itemSelected = previousItem
        objectWillChange.send(self)
    }

    /// This is true when the user has selected the Item with the custom action
    var isCustomItemSelected: Bool = false

    init(initialIndex: Int = 1, customItemIndex: Int) {
        self.customActiontemindex = customItemIndex
        self.itemSelected = initialIndex
        self.previousItem = initialIndex
    }
}

//private let itemFormatter: DateFormatter = {
//    let formatter = DateFormatter()
//    formatter.dateStyle = .short
//    formatter.timeStyle = .medium
//    return formatter
//}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(overViewModel: OverViewModel(), chartViewModel: ChartViewModel(), analysisViewModel: AnalysisViewModel()).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
