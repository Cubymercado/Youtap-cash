//
//  constantCustomers.swift
//  Honcho Lite
//
//  Created by Eugenio Mercado on 7/02/19.
//  Copyright © 2019 Eugenio Mercado. All rights reserved.
//

import Foundation
import CoreData
import UIKit

// MARK: - Entity model

class constantCustomer: NSObject
{
    
    private class func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
        
    }
    
    class func saveObject(customerId: String, name: String, phone: String, address: String, email: String, picture: NSData) -> Bool {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "Customers", in: context)
        let managedObject = NSManagedObject(entity: entity!, insertInto: context)
        
        managedObject.setValue(customerId, forKey: "customerID")
        managedObject.setValue(NSDate(), forKey: "date")
        managedObject.setValue(name, forKey: "name")
        managedObject.setValue(phone, forKey: "phoneNumber")
        managedObject.setValue(address, forKey: "address")
        managedObject.setValue(email, forKey: "email")
        managedObject.setValue(picture, forKey: "profileicture")
        do {
            try context.save()
            return true
        } catch {
            return false
        }  
    }
    
    
    class func fetchObject() -> [Customers]?{
        let context = getContext()
        var myCustomers: [Customers]? = nil
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Customers")
        let sort = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        do {
            myCustomers = try context.fetch(Customers.fetchRequest())
            return myCustomers
        } catch {
            return myCustomers
        }
    }
    
}
