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
    String(format: "%.2f", value)
}

func percentFormat(value: Double) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .percent
    formatter.minimumIntegerDigits = 1
    formatter.maximumIntegerDigits = 3
    formatter.maximumFractionDigits = 2
    return formatter.string(from: value as NSNumber)!
}
func currencyToFlag(currency: String) -> String {
    switch Unit(rawValue: currency)! {
    case .ARS: return "🇦🇷"
    case .AUD: return "🇦🇺"
    case .CHF: return "🇨🇭"
    case .CNY: return "🇨🇳"
    case .EUR: return "🇪🇺"
    case .GBP: return "🇬🇧"
    case .HKD: return "🇭🇰"
    case .JPY: return "🇯🇵"
    case .SGD: return "🇸🇬"
//    case .TWD: return ""
    case .USD: return "🇺🇸"
    case .UnKnow: return ""
    }
}

let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM"
//    formatter.timeStyle = .none
    return formatter
}()

let currencyFormatter: NumberFormatter = {
    let f = NumberFormatter()
//    f.decimalSeparator = "."
//    f.groupingSeparator = "'"
    f.numberStyle = .currency
    f.currencySymbol = ""
    return f
}()

extension String: Identifiable {
    public var id: String {
        self
    }
    
}

extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
