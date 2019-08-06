//
//  constantCategories.swift
//  merchant
//
//  Created by Eugenio Mercado on 9/07/18.
//  Copyright © 2018 Eugenio Mercado. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class constantCategories: NSObject {
    
    private class func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
        
    }
    
    class func saveObject(name:String) -> Bool {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "Categories", in: context)
        let managedObject = NSManagedObject(entity: entity!, insertInto: context)
        
        managedObject.setValue(name, forKey: "name")
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    /*
    class func fetchObject() -> [Categories]? {
        let context = getContext()
        var category: [Categories]? = nil
        
        do {
            category = try context.fetch(Categories.fetchRequest())
            return category
        } catch {
            return category
        }
    }
    */
}

