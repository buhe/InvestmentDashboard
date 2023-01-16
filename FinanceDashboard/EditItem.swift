//
//  EditItem.swift
//  FinanceDashboard
//
//  Created by 顾艳华 on 2023/1/16.
//

import SwiftUI

struct EditItem: View {
    let overview: Overview?
    
    @State private var name = ""
    @State private var value = ""
     let close: () -> Void
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FocusState private var keyFocused: Bool
    
    fileprivate func edit() -> Bool {
        return overview != nil
    }
    
    var body: some View {
        NavigationStack {
            Form {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]){
                    ForEach(ICategroy.all){ c in
                        VStack {
                            switch c {
                            case .Cash:
                                BigImage(system: "dollarsign.circle", categroy: .Cash)
                            case .Bond:
                                BigImage(system: "b.circle", categroy: .Bond)
                            case .Debt:
                                BigImage(system: "creditcard", categroy: .Debt)
                            case .Estate:
                                BigImage(system: "house", categroy: .Estate)
                            case .Fund:
                                BigImage(system: "gauge.high", categroy: .Fund)
                            case .Futures:
                                BigImage(system: "carrot", categroy: .Futures)
                            case .Option:
                                BigImage(system: "target", categroy: .Option)
                            case .Stock:
                                BigImage(system: "waveform.path.ecg", categroy: .Stock)
                                
                            default:
                                Image(systemName: "dollarsign.circle")
                            }
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
//                        .onTapGesture {
//                            keyFocused = true
//                        }
                     
                    }
                }
                .padding()
                TextField("Enter name", text: $name)
                    .focused($keyFocused)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            HStack {
                              
                                TextField("Value:", text: $value).keyboardType(.numberPad)
                                Button(action: addItem) {
                                    Text("Done")
                                }
                            }
                            
                        }
                    }
            }
            .onAppear {
                keyFocused = true
                if edit() {
                    name = overview!.name
                }
//                value = overview.
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
            close()
        }
    }
    
}
//
//struct EditItem_Previews: PreviewProvider {
//    static var previews: some View {
//        EditItem()
//    }
//}
