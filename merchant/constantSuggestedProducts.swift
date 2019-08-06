//
//  constantSuggestedProducts.swift
//  merchant
//
//  Created by Eugenio Mercado on 1/10/18.
//  Copyright © 2018 Eugenio Mercado. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class constantSuggestedProducts: NSObject {
    
    private class func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
        
    }
    
    class func saveObject(name: String, price: Int, description: String, category: String, barcode: String, image: NSData) -> Bool {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "Suggested1", in: context)
        let managedObject = NSManagedObject(entity: entity!, insertInto: context)
        
        managedObject.setValue(name, forKey: "productName")
        managedObject.setValue(price, forKey: "price")
        managedObject.setValue(description, forKey: "productDescription")
        managedObject.setValue(category, forKey: "productCategory")
        managedObject.setValue(barcode, forKey: "barcode")
        managedObject.setValue(image, forKey: "productImage")
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    class func fetchObject() -> [Suggested1]? {
        let context = getContext()
        var products: [Suggested1]? = nil
        
        do {
            products = try context.fetch(Suggested1.fetchRequest())
            return products
        } catch {
            return products
        }
    }
    
}

