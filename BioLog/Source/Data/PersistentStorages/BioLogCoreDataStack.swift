//
//  BioLogCoreDataStack.swift
//  BioLog
//
//  Created by 이현욱 on 4/3/25.
//

import Foundation
import CoreData
import CloudKit

class BioLogCoreDataStack {
    
    static let shared = BioLogCoreDataStack()
    
    let persistentContainer: NSPersistentCloudKitContainer
    let backgroundContext: NSManagedObjectContext
    let mainContext: NSManagedObjectContext
    
    private init() {
        persistentContainer = NSPersistentCloudKitContainer(name: "BioLog")
        
        let description = persistentContainer.persistentStoreDescriptions.first
        description?.cloudKitContainerOptions =
        NSPersistentCloudKitContainerOptions(
            containerIdentifier: "iCloud.com.Wook.BioLog")
        description?.type = NSSQLiteStoreType
        description?.shouldMigrateStoreAutomatically = true
        description?.shouldInferMappingModelAutomatically = true

        
        persistentContainer.loadPersistentStores { description, error in
            guard error == nil else {
                fatalError("was unable to load store \(error!)")
            }
        }
        
    #if DEBUG
        do {
            // Use the container to initialize the development schema.
            try persistentContainer.initializeCloudKitSchema()
        } catch {
            
            if let nsError = error as NSError? {
                print("🌐 Domain: \(nsError.domain)")
                print("❗️ Code: \(nsError.code)")
                print("📝 Description: \(nsError.localizedDescription)")
                print("💬 Failure Reason: \(nsError.localizedFailureReason ?? "None")")
                print("🔧 Recovery Suggestion: \(nsError.localizedRecoverySuggestion ?? "None")")
                print("📚 User Info: \(nsError.userInfo)")
            } else {
                print("알 수 없는 에러: \(error)")
            }
            // Handle any errors.
        }
    #endif
        
        mainContext = persistentContainer.viewContext
        
        backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        backgroundContext.parent = self.mainContext
    }
}
