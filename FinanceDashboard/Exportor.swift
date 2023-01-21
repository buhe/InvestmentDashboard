//
//  Exportor.swift
//  FinanceDashboard
//
//  Created by 顾艳华 on 2023/1/14.
//

import Foundation
import SwiftUI
import CodableCSV
import TPPDF

protocol Exportor {
    func export(items: FetchedResults<Item>) -> Data
}

struct CSV: Exportor {
    func export(items: FetchedResults<Item>) -> Data {
        let datas = items.map{i in
            // todo remove dup by same mouthly
            return ExportData(name: i.name!, categroy: i.categroy!, value: i.value, time: "", unit: i.unit!)}
        let encoder = CSVEncoder { $0.headers = ["name", "categroy", "value", "time", "unit"] }
        let newData = try? encoder.encode(datas)
        print(String(data: newData!, encoding: .utf8)!)
        return newData!
    }
    
    
}

struct Pdf: Exportor {
    func export(items: FetchedResults<Item>) -> Data {
        let document = PDFDocument(format: .a4)
      
        document.add(.contentCenter, text: "Investment Dashboard")
        
        let datas = items.map{i in
            // todo remove dup by same mouthly
            return ExportData(name: i.name!, categroy: i.categroy!, value: i.value, time: "", unit: i.unit!)}
        let table = PDFTable(rows: datas.count + 1, columns: 5)
        datas.enumerated().forEach{
            index,data in
            let row = table[row: index]
            row.content = [data.name,data.categroy,doubleFormat(value: data.value),data.time,data.unit]
        }
        document.add(.contentCenter, table: table)
        let generator = PDFGenerator(document: document)
        let data = try! generator.generateData()
//        let url  = try? generator.generateURL(filename: "Example.pdf")
//        print(url!)
        return data
    }
    
    
}

struct ExportData: Codable {
    let name: String
    let categroy: String
    let value: Double
    let time: String
    let unit: String
}
