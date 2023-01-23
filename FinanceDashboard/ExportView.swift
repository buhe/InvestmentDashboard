//
//  ExportView.swift
//  FinanceDashboard
//
//  Created by 顾艳华 on 2023/1/19.
//

import SwiftUI
import UniformTypeIdentifiers

struct ExportView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.createdDate, ascending: true)],
            animation: .default)
        private var items: FetchedResults<Item>
    @State private var showingExporter = false
    @State private var showingIAP = false
    @State var fileData: Data?
    var body: some View {
      
                
        Button{
            if Model.shared.iap {
                let data = Pdf().export(items: items)
                fileData = data
                showingExporter = true
            } else {
                showingIAP = true
            }
        }label: {
            Text("Export Pdf")
        }
        .buttonStyle(PlainButtonStyle())
        
        .fileExporter(isPresented: $showingExporter, document: PdfFile(data: fileData), contentType: .pdf) { result in
            switch result {
            case .success(let url):
                print("Saved to \(url)")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        .sheet(isPresented: $showingIAP){
            ProView{
                showingIAP = false
            }
        }
        
    }
}

struct PdfFile: FileDocument {
    // tell the system we support only plain text
    static var readableContentTypes = [UTType.pdf]

    // by default our document is empty
    var data: Data?
    
    init(data: Data?) {
        self.data = data
    }
 
    // this initializer loads data that has been saved previously
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            self.data = data
        }
    }

    // this will be called when the system wants to write our data to disk
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        return FileWrapper(regularFileWithContents: data!)
    }
}

struct CsvFile: FileDocument {
    // tell the system we support only plain text
    static var readableContentTypes = [UTType.csv]

    // by default our document is empty
    var data: Data?
    
    init(data: Data?) {
        self.data = data
    }
 
    // this initializer loads data that has been saved previously
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            self.data = data
        }
    }

    // this will be called when the system wants to write our data to disk
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        return FileWrapper(regularFileWithContents: data!)
    }
}

struct ExportView_Previews: PreviewProvider {
    static var previews: some View {
        ExportView()
    }
}

extension UTType {
    static let csv = UTType(importedAs: "dev.buhe.csv")
}
