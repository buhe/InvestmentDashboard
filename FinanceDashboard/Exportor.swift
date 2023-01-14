//
//  Exportor.swift
//  FinanceDashboard
//
//  Created by 顾艳华 on 2023/1/14.
//

import Foundation
import SwiftUI

protocol Exportor {
    func export(items: FetchedResults<Item>) -> String
}

struct CSV: Exportor {
    func export(items: FetchedResults<Item>) -> String {
        ""
    }
    
}
