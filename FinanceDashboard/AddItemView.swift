//
//  AddItemView.swift
//  FinanceDashboard
//
//  Created by 顾艳华 on 2023/1/13.
//

import SwiftUI

struct AddItemView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        NavigationStack {
            Button(action: addItem) {
                Label("Add Item", systemImage: "plus")
            }
        }
        
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

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

struct AddItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemView()
    }
}
