//
//  constantTransactions.swift
//  merchant
//
//  Created by Eugenio Mercado on 9/07/18.
//  Copyright © 2018 Eugenio Mercado. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class constantTransactions: NSObject {
    
    private class func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
        
    }
    
    class func saveObject(amount:String, time:String, payment:String, type:String, latitude:String, longitude:String) -> Bool {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "Transactions3", in: context)
        let managedObject = NSManagedObject(entity: entity!, insertInto: context)
        
        managedObject.setValue(amount, forKey: "amount")
        managedObject.setValue(NSDate(), forKey: "date")
        managedObject.setValue(time, forKey: "time")
        managedObject.setValue(payment, forKey: "payment")
        managedObject.setValue(type, forKey: "type")
        managedObject.setValue(latitude, forKey: "latitude")
        managedObject.setValue(longitude, forKey: "longitude")
        
        
        do { 
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    class func fetchObject() -> [Transactions3]? {
       
       // let date = (NSDate(), forKey: "date")
        let context = getContext()
        var transaction: [Transactions3]? = nil
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Transactions3")
        let sort = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        
        do {
            transaction = try context.fetch(Transactions3.fetchRequest())
            return transaction
        } catch {
            return transaction
        }
    }
    
}

