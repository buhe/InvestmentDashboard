//
//  SDK.swift
//  FinanceDashboard
//
//  Created by 顾艳华 on 2023/1/18.
//

import Foundation
import Alamofire
import SwiftyJSON
import CoreData


struct CurrencySDK {
    static var cache: [String: [String: JSON]] = [:]
    static let URL = "https://v6.exchangerate-api.com/v6/3792021ffe761922812372fe/latest/"
    static func transfer(origion: (Double, Unit), to: Unit, viewContext: NSManagedObjectContext ) async -> (Double ,Unit) {
        let mouth = itemFormatter.string(from: Date.now)
        let base = origion.1.rawValue
        var currency: Double = 1
        if cache[mouth] != nil && cache[mouth]![base] != nil {
            currency = cache[mouth]![base]!["conversion_rates"][to.rawValue].doubleValue
            
        } else {
            let reps = try? await AF.request("\(URL)\(origion.1.rawValue)").serializingString().value
            print("call api.")
            if let reps = reps {
                let json = try? JSON(data: Data(reps.utf8))
                if cache[mouth] == nil {
                    cache[mouth] = [:]
                }
                cache[mouth]![base] = json
                if let json = json {
                    currency = json["conversion_rates"][to.rawValue].doubleValue
                    
                    checkCache(viewContext: viewContext, currentMouth: mouth)
                    
                    let c = Cache(context: viewContext)
                    c.mouth = mouth
                    c.base = base
                    c.json = reps
                    saveToDB(viewContext: viewContext)
                }
            }
        }
        // cache by per unit and mouthly
        
//        print("\(URL)\(origion.1.rawValue)")
      
//        print(reps)
        
//        for (key,subJson):(String, JSON) in json! {
//           // Do something you want
//            print("key \(key)")
//        }
//        print("----\(json!["conversion_rates"]["CNY"])")
        
        var result: (Double, Unit) = (0, to)
        result.0 = origion.0 * currency
//        switch origion.1 {
//        case .USD:
//            result.1 = .CNY
//            result.0 = origion.0 * 7
//        default: break
//        }
        return result
    }
    
    static func saveToDB(viewContext: NSManagedObjectContext) {
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    static func checkCache(viewContext: NSManagedObjectContext, currentMouth: String) {
        let caches = try! viewContext.fetch(NSFetchRequest(entityName: "Cache")) as! [Cache]
        for c in caches {
            if c.mouth! != currentMouth {
                print("Found invailded cache \(c.mouth!)")
                do {
                    viewContext.delete(c)
                    try viewContext.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
            }
        }
    }
    
    static func loadCache(viewContext: NSManagedObjectContext) {
        let caches = try! viewContext.fetch(NSFetchRequest(entityName: "Cache")) as! [Cache]
        
        for c in caches {
            print("Load cache from db \(c.mouth!) \(c.base!)")
            if cache[c.mouth!] == nil {
                cache[c.mouth!] = [:]
            }
            cache[c.mouth!]![c.base!] = JSON(parseJSON: c.json!)
        }
        
    }
}


struct CurrencyResponce: Decodable {
    var result: String
    var documentation: String
    var terms_of_use: String
    var time_last_update_unix: Int
    var time_last_update_utc: String
    var time_next_update_unix: Int
    var time_next_update_utc: String
    var base_code: String
    var conversion_rates: Rates
}

struct Rates: Decodable {
    var USD: Double
    var AED: Double
    var AFN: Double
    var ALL: Double
    var AMD: Double
    var ANG: Double
    var AOA: Double
    var ARS: Double
    var AUD: Double
    var AWG: Double
    var AZN: Double
    var BAM: Double
    var BBD: Double
    var BDT: Double
    var BGN: Double
    var BHD: Double
    var BIF: Double
    var BMD: Double
    var BND: Double
    var BOB: Double
    var BRL: Double
    var BSD: Double
    var BTN: Double
    var BWP: Double
    var BYN: Double
    var BZD: Double
    var CAD: Double
    var CDF: Double
    var CHF: Double
    var CLP: Double
    var CNY: Double
    var COP: Double
    var CRC: Double
    var CUP: Double
    var CVE: Double
    var CZK: Double
    var DJF: Double
    var DKK: Double
    var DOP: Double
    var DZD: Double
    var EGP: Double
    var ERN: Double
    var ETB: Double
    var EUR: Double
    var FJD: Double
    var FKP: Double
    var FOK: Double
    var GBP: Double
    var GEL: Double
    var GGP: Double
    var GHS: Double
    var GIP: Double
    var GMD: Double
    var GNF: Double
    var GTQ: Double
    var GYD: Double
    var HKD: Double
    var HNL: Double
    var HRK: Double
    var HTG: Double
    var HUF: Double
    var IDR: Double
    var ILS: Double
    var IMP: Double
    var INR: Double
    var IQD: Double
    var IRR: Double
    var ISK: Double
    var JEP: Double
    var JMD: Double
    var JOD: Double
    var JPY: Double
    var KES: Double
    var KGS: Double
    var KHR: Double
    var KID: Double
    var KMF: Double
    var KRW: Double
    var KWD: Double
    var KYD: Double
    var KZT: Double
    var LAK: Double
    var LBP: Double
    var LKR: Double
    var LRD: Double
    var LSL: Double
    var LYD: Double
    var MAD: Double
    var MDL: Double
    var MGA: Double
    var MKD: Double
    var MMK: Double
    var MNT: Double
    var MOP: Double
    var MRU: Double
    var MUR: Double
    var MVR: Double
    var MWK: Double
    var MXN: Double
    var MYR: Double
    var MZN: Double
    var NAD: Double
    var NGN: Double
    var NIO: Double
    var NOK: Double
    var NPR: Double
    var NZD: Double
    var OMR: Double
    var PAB: Double
    var PEN: Double
    var PGK: Double
    var PHP: Double
    var PKR: Double
    var PLN: Double
    var PYG: Double
    var QAR: Double
    var RON: Double
    var RSD: Double
    var RUB: Double
    var RWF: Double
    var SAR: Double
    var SBD: Double
    var SCR: Double
    var SDG: Double
    var SEK: Double
    var SGD: Double
    var SHP: Double
    var SLE: Double
    var SLL: Double
    var SOS: Double
    var SRD: Double
    var SSP: Double
    var STN: Double
    var SYP: Double
    var SZL: Double
    var THB: Double
    var TJS: Double
    var TMT: Double
    var TND: Double
    var TOP: Double
    var TRY: Double
    var TTD: Double
    var TVD: Double
    var TWD: Double
    var TZS: Double
    var UAH: Double
    var UGX: Double
    var UYU: Double
    var UZS: Double
    var VES: Double
    var VND: Double
    var VUV: Double
    var WST: Double
    var XAF: Double
    var XCD: Double
    var XDR: Double
    var XOF: Double
    var XPF: Double
    var YER: Double
    var ZAR: Double
    var ZMW: Double
    var ZWL: Double
}
