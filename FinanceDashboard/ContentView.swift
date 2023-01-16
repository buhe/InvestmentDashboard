//
//  ContentView.swift
//  FinanceDashboard
//
//  Created by 顾艳华 on 2023/1/1.
//

import SwiftUI
import CoreData
import Combine

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
//
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
//        animation: .default)
//    private var items: FetchedResults<Item>
    @ObservedObject var overViewModel: OverViewModel
    @ObservedObject var chartViewModel: ChartViewModel
    @ObservedObject private var tabData = MainTabBarData(initialIndex: 1, customItemIndex: 2)


        var body: some View {

            TabView(selection: $tabData.itemSelected) {
                OverView(viewModel: overViewModel)
                    .environment(\.managedObjectContext, viewContext)
                    .tabItem {
                        VStack {
                            Image(systemName: "note.text")
                            Text("Overview")
                        }

                    }.tag(1)

                Text("Add")
                    .tabItem {
                        Image("plus.circle", tintColor: .systemBlue)
                    }
                    .tag(2)

                ChartView(viewModel: chartViewModel)
                    .environment(\.managedObjectContext, viewContext)
                    .tabItem {
                        VStack {
                            Image(systemName: "chart.pie")
                            Text("Chart")
                        }
                }.tag(3)

            }.sheet(isPresented: $tabData.isCustomItemSelected) {
                EditItem(overview: nil) {
                    tabData.itemSelected = tabData.previousItem
                    tabData.isCustomItemSelected = false
                }
                .environment(\.managedObjectContext, viewContext)
            }



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

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(overViewModel: OverViewModel(), chartViewModel: ChartViewModel()).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
