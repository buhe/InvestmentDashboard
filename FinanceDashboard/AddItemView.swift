//
//  AddItemView.swift
//  FinanceDashboard
//
//  Created by 顾艳华 on 2023/1/13.
//

import SwiftUI
import SwiftUIX

struct AddItemView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var name = ""
    @State private var value = ""
    
    var body: some View {
        NavigationStack {
            Form {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]){
                    ForEach(0 ..< 6){ index in
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(Color(hue: 0.03 * Double(index) , saturation: 1, brightness: 1))
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
                            .overlay(Text("\(index)"))
                    }
                }
                .padding()
                TextField("Enter name", text: $name)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            HStack {
                                Text("Value: ")
                                
                                TextField("Value:", text: $value).keyboardType(.numberPad)
                                Button(action: addItem) {
                                    Text("Done")
                                }
                            }
                            
                        }
                    }
            }
            
        }
        
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.createdDate = Date()
            newItem.name = "123"
            newItem.updatedDate = Date.now

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
