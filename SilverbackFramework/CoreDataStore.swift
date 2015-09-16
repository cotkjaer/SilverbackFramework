//
//  CoreDataStore.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 21/04/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import CoreData

public enum CoreDataStoreType
{
    case SQLite, Binary, InMemory
    
    internal var persistentStoreType : String
        {
            switch self
            {
            case .SQLite:
                return NSSQLiteStoreType
            case .InMemory:
                return NSInMemoryStoreType
            case .Binary:
                return NSBinaryStoreType
            }
    }
    
    internal func persistentStoreFileURL(modelName: String) -> NSURL?
    {
        do {
            let documentsDirectoryURL = try NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory,
                inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
            switch self
            {
            case .SQLite:
                return documentsDirectoryURL.URLByAppendingPathComponent(modelName + ".sqlite")
            case .InMemory:
                return nil
            case .Binary:
                return documentsDirectoryURL.URLByAppendingPathComponent(modelName + ".bin")
            }
        } catch _ {
        }
        return nil
    }
}

public class CoreDataStore
{
    let persistentStoreCoordinator: NSPersistentStoreCoordinator!
    
    public convenience init?(modelName: String, storeType: CoreDataStoreType = .SQLite, error: NSErrorPointer? = nil)
    {
        self.init(modelName:modelName, inBundle: NSBundle.mainBundle(), storeType: storeType, error:error)
    }
    
    public required init?(modelName: String, inBundle bundle: NSBundle, storeType: CoreDataStoreType = .SQLite, error: NSErrorPointer? = nil)
    {
        if let modelURL = bundle.URLForResource(modelName, withExtension: "momd")
        {
            if let model = NSManagedObjectModel(contentsOfURL: modelURL)
            {
                let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
     
                var internalError: NSError? = nil

                do {
                    let _ = try persistentStoreCoordinator.addPersistentStoreWithType(
                        storeType.persistentStoreType,
                        configuration: nil,
                        URL: storeType.persistentStoreFileURL(modelName),
                        options: nil)
                    self.persistentStoreCoordinator = persistentStoreCoordinator
                    
                    return
                } catch let error as NSError {
                    internalError = error
                }
                
                error?.memory = NSError(domain: "CoreDataStore", code: 3, description: "Failed to create CoreDataStore", reason: "Could not create Persistent Store", underlyingError: internalError)
            }
            else
            {
                error?.memory = NSError(domain: "CoreDataStore", code: 2, description: "Failed to create CoreDataStore", reason: "Could not create ManagedObject model from URL \(modelURL)", underlyingError: nil)
            }
        }
        else
        {
            error?.memory = NSError(domain: "CoreDataStore", code: 1, description: "Failed to create CoreDataStore", reason: "Could not find ManagedObject model called \(modelName) in \(bundle)", underlyingError: nil)
        }
        
        self.persistentStoreCoordinator = nil
        
        return nil
    }
}

