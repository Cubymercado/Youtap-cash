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
    var code: String
    var symbol: String
    var decimals: Int
    var image: String
    var locale: String
    
    var dictionary: [String: Any] {
        return [
            "currency": code,
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
            let code = dictionary["code"] as? String,
            let symbol = dictionary["symbol"] as? String,
            let decimals = dictionary["code"] as? Int,
            let locale = dictionary["locale"] as? String
        
            else {return nil}
        let image = dictionary["image"] as? String
        let defaultImage: String = image ?? "https://www.countryflags.io/nz/flat/16.png"
        
        self.init(name: name, code: code, symbol: symbol, decimals: decimals, image: defaultImage, locale: locale)
    }
    
    
}
