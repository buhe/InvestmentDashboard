//
//  Ex.swift
//  FinanceDashboard
//
//  Created by 顾艳华 on 2023/1/14.
//

import Foundation
import SwiftUI

extension Image {
    init(_ named: String, tintColor: UIColor) {
        let uiImage = UIImage(systemName: named) ?? UIImage()
        let tintedImage = uiImage.withTintColor(tintColor, renderingMode: .alwaysOriginal)
        self = Image(uiImage: tintedImage)
    }
}

extension View {
    func border(width: CGFloat, edges: [Edge], color: SwiftUI.Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
}
