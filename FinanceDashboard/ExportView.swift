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
    @State var fileData: String?
    var body: some View {
        List {
            Group{
                Button{
                    
                    
                    CSV().export(items: items)
                    fileData = "test"
                    showingExporter = true
                }label: {
                    Text("Export CSV")
                }
                
                Button{
                    Pdf().export(items: items)
                }label: {
                    Text("Export Pdf")
                }
            }
            .fileExporter(isPresented: $showingExporter, document: TextFile(initialText: fileData ?? ""), contentType: .plainText) { result in
                switch result {
                case .success(let url):
                    print("Saved to \(url)")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
    }
}

struct TextFile: FileDocument {
    // tell the system we support only plain text
    static var readableContentTypes = [UTType.plainText]

    // by default our document is empty
    var text = ""

    // a simple initializer that creates new, empty documents
    init(initialText: String = "") {
        text = initialText
    }

    // this initializer loads data that has been saved previously
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            text = String(decoding: data, as: UTF8.self)
        }
    }

    // this will be called when the system wants to write our data to disk
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = Data(text.utf8)
        return FileWrapper(regularFileWithContents: data)
    }
}

struct ExportView_Previews: PreviewProvider {
    static var previews: some View {
        ExportView()
    }
}
