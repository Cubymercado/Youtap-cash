//
//  promoProducts.swift
//  Youtap Merchant
//
//  Created by Eugenio Mercado on 30/10/18.
//  Copyright © 2018 Eugenio Mercado. All rights reserved.
//

import Foundation
import Firebase

// A type that can be initialized from a Firestore document.
protocol DocumentSerializablePromotions {
    init?(dictionary: [String: Any])
}

struct promoProducts {
    
    var product: String
    var specialPrice: String
    var expiracy: String
    var description: String
    var image: String
    
    var dictionary: [String: Any] {
        return [
            
            "Product": product,
            "Price": specialPrice,
            "Expiracy": expiracy,
            "Description": description,
            "Image": image
            
            
        ]
        
        
    }
    
}

extension promoProducts: DocumentSerializablePromotions {
    
    init?(dictionary: [String : Any]) {
        guard let product = dictionary["Product"] as? String,
            let description = dictionary["Description"] as? String,
            let image = (dictionary["Image"] as? String)
            
            else { return nil }
        let expiracy = dictionary["Expiracy"] as? String
        let defaultExpiracy: String = expiracy ?? "No expiracy"
        
        let specialPrice = dictionary["Price"] as? String
        let defaultPrice: String = specialPrice ?? "0"
        
        self.init(product: product,
                  specialPrice: defaultPrice,
                  expiracy: defaultExpiracy,
                  description: description,
                  image: image)
    }
    
    
    
    
    
}
