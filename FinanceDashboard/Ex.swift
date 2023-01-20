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

extension Sequence {
    func asyncForEach(
        _ operation: (Element) async throws -> Void
    ) async rethrows {
        for element in self {
            try await operation(element)
        }
    }
    
    func asyncMap<T>(
          _ transform: (Element) async throws -> T
      ) async rethrows -> [T] {
          var values = [T]()

          for element in self {
              try await values.append(transform(element))
          }

          return values
      }
}

func doubleFormat(value: Double) -> String {
    String(format: "%.f", value)
}

let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM"
//    formatter.timeStyle = .none
    return formatter
}()

extension String: Identifiable {
    public var id: String {
        self
    }
    
}
