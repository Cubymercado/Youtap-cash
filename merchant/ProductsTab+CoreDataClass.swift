//
//  ProductsTab+CoreDataClass.swift
//  Honcho Lite
//
//  Created by Eugenio Mercado on 4/03/19.
//  Copyright © 2019 Eugenio Mercado. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit


public class ProductsTab: NSManagedObject {

    var dates : Date?{
        get{
            return date as Date?
        }
        set{
            date = newValue as NSDate?
        }
    }
    
    convenience init?(price:Int32?, name:String?, date:Date?){
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        guard let context = appDelegate?.persistentContainer.viewContext
            else{
                return nil
        }
        self.init(entity: ProductsTab.entity(), insertInto: context)
        self.price = price ?? 0
        self.name = name
        self.date = (date! as NSDate)
    }
    
    func update(price:Int32?, name:String?, date:Date?){
        self.price = price ?? 0
        self.name = name
        self.date = (date! as NSDate)
    }
    
}
