//
//  supportedCurrencies.swift
//  Honcho Lite
//
//  Created by Eugenio Mercado on 6/8/19.
//  Copyright © 2019 Eugenio Mercado. All rights reserved.
//

import Foundation
import Firebase

protocol DocumentSerializableSupportedCurrencies {
    init?(dictionary: [String: Any])
}

struct supportedCurrencies {
    
    var name: String
    var currency: String
    var symbol: String
    var decimals: Int
    var image: String
    var locale: String
    
    var dictionary: [String: Any] {
        return [
            "currency": currency,
            "name": name,
            "symbol": symbol,
            "decimals": decimals,
            "image": image,
            "locale": locale
        ]
    }
}


extension supportedCurrencies: DocumentSerializableSupportedCurrencies {
    init?(dictionary: [String : Any]) {
        guard let name = dictionary["name"] as? String,
        let currency = dictionary["currency"] as? String
        
        
            else {return nil}
       
        let image = dictionary["image"] as? String
        let locale = dictionary["locale"] as? String
        let symbol = dictionary["symbol"] as? String
        let decimals = dictionary["decimals"] as? Int
        
        
        let defaultImage: String = image ?? "https://www.countryflags.io/nz/flat/16.png"
        let defaultSymbol: String = symbol ?? "  $"
        let defaultLocale: String = locale ?? " en"
        let defaultDecimals: Int = decimals ?? 2
       // let defaultCurrency: String = currency ?? "  $"
        
        self.init(name: name, currency: currency, symbol: defaultSymbol, decimals: defaultDecimals, image: defaultImage, locale: defaultLocale)
    }
    
    
}
