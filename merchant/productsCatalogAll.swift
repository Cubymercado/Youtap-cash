//
//  productsCatalogAll.swift
//  Youtap Merchant
//
//  Created by Eugenio Mercado on 27/11/18.
//  Copyright © 2018 Eugenio Mercado. All rights reserved.
//

import Foundation
import Firebase

protocol DocumentSerializableProductsCatalogAll{
    init?(dictionary: [String: Any])
}

struct productsCatalogAll {
    
    var brand: String
    var category: String
    var description: String
    var name: String
    var productImageRectangle: String
    var productImageSquare: String
    var quantity: String
    var size: String
    var suggestedPrice: Int
    var supplierID: Int
    var unitPrice: Int
    var unitSKU: String
    
    var dictionary: [String: Any] {
        return [
            
            "Brand": brand,
            "Category": category,
            "Description": description,
            "Name": name,
            "Product Image Rectangle": productImageRectangle,
            "Product Image Square": productImageSquare,
            "Quantity": quantity,
            "Size": size,
            "Suggested Price": suggestedPrice,
            "Supplier ID": supplierID,
            "Unit Price": unitPrice,
            "Unit SKU": unitSKU
        ]
    }
    
}

extension productsCatalogAll: DocumentSerializableProductsCatalogAll{
    init?(dictionary: [String : Any]) {
        guard let name = dictionary["Name"] as? String,
            let brand = dictionary["Brand"] as? String,
            let category = dictionary["Category"] as? String,
            let productImageRectangle = dictionary["Product Image Rectangle"] as? String,
            let productImageSquare = dictionary["Product Image Square"] as? String,
            let quantity = dictionary["Quantity"] as? String,
            let size = dictionary["Size"] as? String,
            let suggestedPrice = dictionary["Suggested Price"] as? Int,
            let supplierID = dictionary["Supplier ID"] as? Int,
            let unitPrice = dictionary["Unit Price"] as? Int,
            let unitSKU = dictionary["Unit SKU"] as? String
            
            else {return nil}
        let description = dictionary["Description"] as? String
        let defaultDescription: String = description ?? "This item has not yet been properly described by our team of writing monkeys"
        
        self.init(brand: brand, category: category, description: defaultDescription, name: name, productImageRectangle: productImageRectangle, productImageSquare: productImageSquare, quantity: quantity, size: size, suggestedPrice: suggestedPrice, supplierID: supplierID, unitPrice: unitPrice, unitSKU: unitSKU)
    }
    
    
    
}
