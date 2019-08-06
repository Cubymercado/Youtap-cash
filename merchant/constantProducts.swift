//
//  constantProducts.swift
//  merchant
//
//  Created by Eugenio Mercado on 9/07/18.
//  Copyright © 2018 Eugenio Mercado. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class constantProducts: NSObject {

private class func getContext() -> NSManagedObjectContext {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    return appDelegate.persistentContainer.viewContext
    
}

    class func saveObject(name:String, price:Int, category:String, size:String, inventory: Int, barcode:String, image:NSData) -> Bool {
    let context = getContext()
    let entity = NSEntityDescription.entity(forEntityName: "Products1", in: context)
    let managedObject = NSManagedObject(entity: entity!, insertInto: context)
    
        managedObject.setValue(name, forKey: "name")
        managedObject.setValue(price, forKey: "price")
        managedObject.setValue(category, forKey: "category")
        managedObject.setValue(size, forKey: "size")
        managedObject.setValue(image, forKey: "image")
        managedObject.setValue(barcode, forKey: "barcode")
        managedObject.setValue(inventory, forKey: "inventory")
        
    do {
        try context.save()
        return true
        
    } catch {
        
        return false
    }
}

class func fetchObject() -> [Products1]? {
    let context = getContext()
    var products: [Products1]? = nil
    
    do {
        products = try context.fetch(Products1.fetchRequest())
        return products
    } catch {
        return products
    }
}

}
