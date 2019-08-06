//
//  Customers+CoreDataClass.swift
//  Honcho Lite
//
//  Created by Eugenio Mercado on 4/03/19.
//  Copyright © 2019 Eugenio Mercado. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit

@objc(Customers)
public class Customers: NSManagedObject {

    var productTabClass: [ProductsTab]?{
        return self.rawProductsTab?.array as? [ProductsTab]
    }
    
    convenience init?(name : String?, customerId: String?, phone: String?, address: String?, email: String?, picture: NSData?, date: NSDate){
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        guard let context = appDelegate?.persistentContainer.viewContext
            else{
                return nil
        }
        self.init(entity: Customers.entity(), insertInto: context)
        self.name = name
        self.customerID = customerId
        self.phoneNumber = phone
        self.address = address
        self.email = email
        self.profileicture = picture
        self.date = date
    }
    
    func update(name : String?, customerId: String?, phone: String?, address: String?, email: String?, picture: NSData?, date: NSDate){
        
        self.name = name
        self.customerID = customerId
        self.phoneNumber = phone
        self.address = address
        self.email = email
        self.profileicture = picture
        self.date = date
    }

}









