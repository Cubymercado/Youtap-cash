//
//  constantCart.swift
//  merchant
//
//  Created by Eugenio Mercado on 26/07/18.
//  Copyright © 2018 Eugenio Mercado. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class constantCart: NSObject {
    
    private class func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    
    
}
 
    class func saveObject(product: String, price: Int, inventory: Int, productImage: NSData, productDescription: String, documentID: String) -> Bool {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "Cart", in: context)
        let managedObject = NSManagedObject(entity: entity!, insertInto: context)
        
        managedObject.setValue(product, forKey: "product")
        managedObject.setValue(price, forKey: "price")
        managedObject.setValue(inventory, forKey: "inventory")
        managedObject.setValue(productImage, forKey: "productImage")
        managedObject.setValue(productDescription, forKey: "productDescription")
        managedObject.setValue(documentID, forKey: "documentID")
        do { 
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    
    class func fetchObject() -> [Cart]? {
        let context = getContext()
        var myCart: [Cart]? = nil
        
        do {
            myCart = try context.fetch(Cart.fetchRequest())
            return myCart
        } catch {
            return myCart
        }
    }
    
}
