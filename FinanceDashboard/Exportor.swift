//
//  Exportor.swift
//  FinanceDashboard
//
//  Created by 顾艳华 on 2023/1/14.
//

import Foundation
import SwiftUI
import CodableCSV

protocol Exportor {
    func export(items: FetchedResults<Item>)
}

struct CSV: Exportor {
    func export(items: FetchedResults<Item>) {
        let datas = items.map{i in
            // todo remove dup by same mouthly
            return ExportData(name: i.name!, categroy: i.categroy!, value: i.value, time: "", unit: i.unit!)}
        let encoder = CSVEncoder { $0.headers = ["name", "categroy", "value", "time", "unit"] }
        let newData = try? encoder.encode(datas)
        print(String(data: newData!, encoding: .utf8)!)
    }
    
    
}

struct ExportData: Codable {
    let name: String
    let categroy: String
    let value: Double
    let time: String
    let unit: String
}
