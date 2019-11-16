//
//  Document+CoreDataProperties.swift
//  Document Core Data
//
//  Created by Carmel Braga on 11/16/19.
//  Copyright © 2019 Carmel Braga. All rights reserved.
//
//

import Foundation
import CoreData


extension Document {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Document> {
        return NSFetchRequest<Document>(entityName: "Document")
    }

    @NSManaged public var documentContent: String?
    @NSManaged public var documentDate: NSDate?
    @NSManaged public var documentName: String?
    @NSManaged public var size: Int64

}
