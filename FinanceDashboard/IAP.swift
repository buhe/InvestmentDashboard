//
//  IAP.swift
//  FinanceDashboard
//
//  Created by 顾艳华 on 2023/1/17.
//

import Foundation



import StoreKit
class IAPManager: NSObject {
    
    static let shared = IAPManager()
    var products = [SKProduct]()
    fileprivate var productRequest: SKProductsRequest!
func getProductID() -> [String] {
        ["dev.buhe.FinanceDashboard.pro"]
    }
    
    func getProducts() {
        let productIds = getProductID()
        let productIdsSet = Set(productIds)
        productRequest = SKProductsRequest(productIdentifiers: productIdsSet)
        productRequest.delegate = self
        productRequest.start()
    }
}
extension IAPManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        response.products.forEach {
            print($0.localizedTitle, $0.price, $0.localizedDescription)
        }
        self.products = response.products
    }
    
}
