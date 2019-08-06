//
//  supplierProducts.swift
//  merchant
//
//  Created by Eugenio Mercado on 30/07/18.
//  Copyright © 2018 Eugenio Mercado. All rights reserved.
//

import Foundation
import Firebase

// A type that can be initialized from a Firestore document.
protocol DocumentSerializable {
    init?(dictionary: [String: Any])
}

struct supplierProducts {
    
    var product: String
    var size: String
    var recommendedPrice: String
    var category: String
    var barcode: String
    var image: String
    
    var dictionary: [String: Any] {
        return [
        
            "Product": product,
            "Category": category,
            "Price": recommendedPrice,
            "Barcode": barcode,
            "Size": size,
            "Image": image
            
        ]
        
        
    }
    
}

extension supplierProducts: DocumentSerializable {
    
    init?(dictionary: [String : Any]) {
        guard let product = dictionary["Product"] as? String,
            let size = dictionary["Size"] as? String,
            let category = dictionary["Category"] as? String,
            let image = (dictionary["Image"] as? String)
        
    else { return nil }
        let barcode = dictionary["Barcode"] as? String
        let defaultBarcode: String = barcode ?? "No barcode"
        
        let recommendedPrice = dictionary["Price"] as? String
        let defaultPrice: String = recommendedPrice ?? "0"
        
        self.init(product: product,
                  size: size,
                  recommendedPrice: defaultPrice,
                  category: category,
                  barcode: defaultBarcode,
                  image: image)
    }
   
    
    
    
    
}
