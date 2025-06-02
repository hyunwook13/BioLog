//
//  BookMigrationPolicy.swift
//  BioLog
//
//  Created by 이현욱 on 4/7/25.
//

import Foundation
import CoreData

final class BookMigrationPolicy: NSEntityMigrationPolicy {
    override func createDestinationInstances(
        forSource sourceInstance: NSManagedObject,
        in mapping: NSEntityMapping,
        manager: NSMigrationManager
    ) throws {
        try super.createDestinationInstances(forSource: sourceInstance, in: mapping, manager: manager)
        
        guard let book = manager.destinationInstances(forEntityMappingName: mapping.name, sourceInstances: [sourceInstance]).first else {
            return
        }

        if let bookmarked = sourceInstance.value(forKey: "BookInfo") as? NSManagedObject {
            let isAdded = bookmarked.value(forKey: "addedDate") as? Date ?? Date()
            book.setValue(isAdded, forKey: "addedDate")
        }
    }
}
