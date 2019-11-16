//
//  Document+CoreDataClass.swift
//  Document Core Data
//
//  Created by Carmel Braga on 11/16/19.
//  Copyright © 2019 Carmel Braga. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit

@objc(Document)
public class Document: NSManagedObject {
    var modifiedDate: Date? {
           get {
               return documentDate as Date?
           }
           set {
               documentDate = newValue as NSDate?
           }
       }
    
    convenience init?(documentName: String?, documentContent: String?){
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            
            guard let managedContext = appDelegate?.persistentContainer.viewContext,
                let documentName = documentName, documentName != "" else {
                              return nil
            }
            
            self.init(entity: Document.entity(), insertInto: managedContext)
                   self.documentName = documentName
                   self.documentContent = documentContent
                   if let size = documentContent?.count {
                       self.size = Int64(size)
                   } else {
                       self.size = 0
                   }
                   
                   self.modifiedDate = Date(timeIntervalSinceNow: 0)
               }
               
               func update(documentName: String, documentContent: String?) {
                   self.documentName = documentName
                   self.documentContent = documentContent
                   if let size = documentContent?.count {
                       self.size = Int64(size)
                   } else {
                       self.size = 0
                   }
               
                   self.modifiedDate = Date(timeIntervalSinceNow: 0)
               }
            }

