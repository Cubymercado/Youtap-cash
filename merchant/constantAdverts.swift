//
//  constantAdverts.swift
//  Honcho Lite
//
//  Created by Eugenio Mercado on 18/6/19.
//  Copyright © 2019 Eugenio Mercado. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class constantAdverts: NSObject {
    
    private class func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
        
        
    }
    
    class func saveObject(promotionalLabel: String, advertImage: NSData, documentID: String) -> Bool {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "AdvertImages", in: context)
        let managedObject = NSManagedObject(entity: entity!, insertInto: context)
        
        managedObject.setValue(advertImage, forKey: "advertImage")
        managedObject.setValue(promotionalLabel, forKey: "promotionalLabel")
        managedObject.setValue(documentID, forKey: "documentID")
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    
    class func fetchObject() -> [AdvertImages]? {
        let context = getContext()
        var advertImages: [AdvertImages]? = nil
        
        do {
            advertImages = try context.fetch(AdvertImages.fetchRequest())
            return advertImages
        } catch {
            return advertImages
        }
    }
    
}
