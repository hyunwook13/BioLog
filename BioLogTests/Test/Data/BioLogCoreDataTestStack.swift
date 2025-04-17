//
//  BioLogCoreDataTestStack.swift
//  BioLogTests
//
//  Created by 이현욱 on 4/3/25.
//

import Foundation
import CoreData

// https://www.youtube.com/watch?v=DTz_MFxe9mk&ab_channel=SwiftArcade

class BioLogCoreDataTestStack {
    
    let persistentContainer: NSPersistentContainer
    let backgroundContext: NSManagedObjectContext
    let mainContext: NSManagedObjectContext
    
    init() {
        persistentContainer = NSPersistentContainer(name: "BioLog")
        let description = persistentContainer.persistentStoreDescriptions.first
        description?.type = NSInMemoryStoreType
        
        persistentContainer.loadPersistentStores { description, error in
            guard error == nil else {
                fatalError("was unable to load store \(error!)")
            }
        }
        
        mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainContext.automaticallyMergesChangesFromParent = true
        mainContext.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator

        backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        backgroundContext.parent = self.mainContext
    }
}

