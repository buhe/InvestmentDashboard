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
    @State private var selectCategroy: ICategroy = .Cash
    @State var currency: String
    
    
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
                                BigImage(systemName: selectCategroy == .Cash ? "dollarsign.circle.fill" : "dollarsign.circle", categroy: .Cash)
                                    .onTapGesture {
                                        selectCategroy = .Cash
                                    }
                            case .Bond:
                                BigImage(systemName: selectCategroy == .Bond ? "b.circle.fill" : "b.circle", categroy: .Bond)
                                    .onTapGesture {
                                        selectCategroy = .Bond
                                    }
                            case .Debt:
                                BigImage(systemName: selectCategroy == .Debt ? "creditcard.fill" : "creditcard", categroy: .Debt)
                                    .onTapGesture {
                                        selectCategroy = .Debt
                                    }
                            case .Estate:
                                BigImage(systemName: selectCategroy == .Estate ? "house.fill" : "house", categroy: .Estate)
                                    .onTapGesture {
                                        selectCategroy = .Estate
                                    }
                            case .Fund:
                                BigImage(systemName: selectCategroy == .Fund ? "dial.high.fill" : "dial.high", categroy: .Fund)
                                    .onTapGesture {
                                        selectCategroy = .Fund
                                    }
                            case .Futures:
                                BigImage(systemName: selectCategroy == .Futures ? "carrot.fill" : "carrot", categroy: .Futures)
                                    .onTapGesture {
                                        selectCategroy = .Futures
                                    }
                            case .Option:
                                BigImage(systemName: selectCategroy == .Option ? "envelope.fill" : "envelope", categroy: .Option)
                                    .onTapGesture {
                                        selectCategroy = .Option
                                    }
                            case .Stock:
                                BigImage(systemName: selectCategroy == .Stock ? "waveform.path.ecg.rectangle.fill" :  "waveform.path.ecg.rectangle", categroy: .Stock)
                                    .onTapGesture {
                                        selectCategroy = .Stock
                                    }
                            case .Savings:
                                BigImage(systemName: selectCategroy == .Savings ? "banknote.fill" :  "banknote", categroy: .Savings)
                                    .onTapGesture {
                                        selectCategroy = .Savings
                                    }
                               
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
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.never)
                    .focused($keyFocused)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            HStack {
                              
                                TextField("Value:", text: $value)
                                    .disableAutocorrection(true)
                                    .textInputAutocapitalization(.never)
                                    .keyboardType(.numberPad)
                                Picker("Currency", selection: $currency){
                                    ForEach(Unit.allCases, id: \.self){
                                        Text($0.rawValue)
                                    }
                                    
                                }
                                Button(action: addItem) {
                                    Text("Done")
                                }
                            }
                            
                        }
                    }
            }
            .toolbar{
                if edit() {
                    Button(action: deleteItems) {
                        Image(systemName: "trash")
                    }
                }
            }
            .onAppear {
                keyFocused = true
                if edit() {
                    name = overview!.name
                    
                    selectCategroy = overview!.categroy
                    value = String(format: "%f", overview!.value)
                }
//                value = overview.
            }
            
        }
    }
    
    fileprivate func changeNameOrCategroy(oldItem: Item) -> Bool {
        oldItem.name! != name || oldItem.categroy! != selectCategroy.rawValue
    }
    
    private func addItem() {
        if let v = Double(value) {
            withAnimation {
                if edit() {
                    let oldItem = overview!.raw
                    if changeNameOrCategroy(oldItem: oldItem) {
                        oldItem.updatedDate = Date.now
                        oldItem.name = name
                        oldItem.categroy = selectCategroy.rawValue
                        oldItem.value = v
                    } else {
                        let newItem = Item(context: viewContext)
                        let now = Date.now
                        newItem.createdDate = oldItem.createdDate
                        newItem.name = oldItem.name
                        newItem.categroy = oldItem.categroy
                        newItem.updatedDate = now
                        newItem.value = v
                    }
                    
                } else {
                    let newItem = Item(context: viewContext)
                    let now = Date.now
                    newItem.createdDate = now
                    newItem.name = name
                    newItem.categroy = selectCategroy.rawValue
                    newItem.updatedDate = now
                    newItem.value = v
                    // for test
                    for i in 1...8 {
                        let newItem2 = Item(context: viewContext)
                    
                        newItem2.createdDate = Calendar.current.date(byAdding: .month, value: -i, to: now)!
                        newItem2.name = name
                        newItem2.categroy = selectCategroy.rawValue
                        newItem2.updatedDate = Calendar.current.date(byAdding: .month, value: -i, to: now)!
                        newItem2.value = v - Double(i) * 100
                    }
                    
                }
                
            }
        } else {
            // show err
            return
        }
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
    
    private func deleteItems() {
            withAnimation {
                viewContext.delete(overview!.raw)
    
                do {
                    try viewContext.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
            }
        close()
        }
    
}
//
//struct EditItem_Previews: PreviewProvider {
//    static var previews: some View {
//        EditItem()
//    }
//}
