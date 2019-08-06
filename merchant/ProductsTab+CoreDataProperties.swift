//
//  ProductsTab+CoreDataProperties.swift
//  Honcho Lite
//
//  Created by Eugenio Mercado on 4/03/19.
//  Copyright © 2019 Eugenio Mercado. All rights reserved.
//
//

import Foundation
import CoreData


extension ProductsTab {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductsTab> {
        return NSFetchRequest<ProductsTab>(entityName: "ProductsTab")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var name: String?
    @NSManaged public var price: Int32
    @NSManaged public var rawCustomer: Customers?

}

extension ProductsTab{
    @objc(addRawProductsTabObject:)
    @NSManaged public func addToRawCustomers(_ value: Customers)
    
    @objc(addRawProductsTab:)
    @NSManaged public func addToRawCustomer(_ values: NSOrderedSet)
    
}
