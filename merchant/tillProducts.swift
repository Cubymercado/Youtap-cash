//
//  tillProducts.swift
//  Youtap Merchant
//
//  Created by Eugenio Mercado on 20/12/18.
//  Copyright © 2018 Eugenio Mercado. All rights reserved.
//

import Foundation
import Firebase



struct tillProducts{
    
    var product: String
    var description: String
    var price: String
    var image: String
    var id: String
    
    var dictionary: [String: Any] {
        return [
            
            "product": product,
            "description": description,
            "price": price,
            "image": image
        ]
        
    }
    
}

extension tillProducts {
    
    init?(dictionary: [String: Any], id: String) {
        guard let product = dictionary["product"] as? String,
            let description = dictionary["description"] as? String,
            let price = dictionary["price"] as? String
            
            else {return nil}
        let image = dictionary["image"] as? String
        let defaultImage: String = image ?? "https://firebasestorage.googleapis.com/v0/b/honcho-app.appspot.com/o/Random-product%403x.png?alt=media&token=4a83f323-9361-4cd3-ad88-fb56a335dffa"
        
        self.init(product: product, description: description, price: price, image: defaultImage, id: id)
    }
    
    
}
