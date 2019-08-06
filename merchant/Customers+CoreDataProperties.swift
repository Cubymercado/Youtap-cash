//
//  Customers+CoreDataProperties.swift
//  Honcho Lite
//
//  Created by Eugenio Mercado on 4/03/19.
//  Copyright © 2019 Eugenio Mercado. All rights reserved.
//
//

import Foundation
import CoreData


extension Customers {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Customers> {
        return NSFetchRequest<Customers>(entityName: "Customers1")
    }

    @NSManaged public var address: String?
    @NSManaged public var customerID: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var email: String?
    @NSManaged public var name: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var profileicture: NSData?
    @NSManaged public var rawProductsTab: NSOrderedSet?

}

// MARK: Generated accessors for rawProductsTab
extension Customers {

    @objc(addRawProductsTabObject:)
    @NSManaged public func addToRawProductsTab(_ value: ProductsTab)

    @objc(removeRawProductsTabObject:)
    @NSManaged public func removeFromRawProductsTab(_ value: ProductsTab)

    @objc(addRawProductsTab:)
    @NSManaged public func addToRawProductsTab(_ values: NSOrderedSet)
    
    @objc(insertObject:inRawDocumentsAtIndex:)
    @NSManaged public func insertIntoRawProductsTab(_ value: ProductsTab, at idx: Int)
    
    @objc(removeObjectFromRawDocumentsAtIndex:)
    @NSManaged public func removeFromRawProductsTab(at idx: Int)
    
    @objc(insertRawDocuments:atIndexes:)
    @NSManaged public func insertIntoRawProductsTab(_ values: [ProductsTab], at indexes: NSIndexSet)
    
    @objc(removeRawDocumentsAtIndexes:)
    @NSManaged public func removeFromRawProductsTab(at indexes: NSIndexSet)
    
    @objc(replaceObjectInRawDocumentsAtIndex:withObject:)
    @NSManaged public func replaceRawProductsTab(at idx: Int, with value: ProductsTab)
    
    @objc(replaceRawDocumentsAtIndexes:withRawDocuments:)
    @NSManaged public func replaceRawProductsTab(at indexes: NSIndexSet, with values: [ProductsTab])
    
    @objc(removeRawDocuments:)
    @NSManaged public func removeFromRawProductsTab(_ values: NSOrderedSet)

}
