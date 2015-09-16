//
//  NSPersistentStoreCoordinator.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 22/04/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import CoreData

public enum NSPersistentStoreType
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
    
    private func persistentStoreFileURL(modelName: String, fileExtension: String) throws -> NSURL
    {
        var error: NSError! = NSError(domain: "Migrator", code: 0, userInfo: nil)
        do {
            let documentsDirectoryURL = try NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory,
                inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
            return documentsDirectoryURL.URLByAppendingPathComponent(modelName + "." + fileExtension)
        } catch let error1 as NSError {
            error = error1
        }
        
        throw error
    }
    
    internal func persistentStoreFileURL(modelName: String) throws -> NSURL
    {
        let error: NSError! = NSError(domain: "Migrator", code: 0, userInfo: nil)
        switch self
        {
        case .SQLite:
            do {
                return try persistentStoreFileURL(modelName, fileExtension: "sqlite")
            } catch _ {
                throw error
            }
        case .InMemory:
            throw error
        case .Binary:
            do {
                return try persistentStoreFileURL(modelName, fileExtension: "sqlite")
            } catch _ {
                throw error
            }
        }
    }
}

func managedObjectModelWithName(name: String?, inBundle bundle: NSBundle?) throws -> NSManagedObjectModel
{
    var error: NSError! = NSError(domain: "Migrator", code: 0, userInfo: nil)
    let realBundle = (bundle ?? NSBundle.mainBundle())
    
    if let modelName = name
    {
        if let modelURL = realBundle.URLForResource(modelName, withExtension: "momd")
        {
            if let model = NSManagedObjectModel(contentsOfURL: modelURL)
            {
                return model
            }
            else {
                error = NSError(domain: "NSPersistentStoreCoordinator", code: 2, description: "Failed to create NSPersistentStoreCoordinator", reason: "Could not create ManagedObject model from URL \(modelURL)", underlyingError: nil)
            }
        }
        else {
            error = NSError(domain: "NSPersistentStoreCoordinator", code: 1, description: "Failed to create NSPersistentStoreCoordinator", reason: "Could not find ManagedObject model called \(modelName) in \(realBundle)", underlyingError: nil)
        }
    }
    else
    {
        if let model = NSManagedObjectModel.mergedModelFromBundles([realBundle])
        {
            return model
        }
        else {
            error = NSError(domain: "NSPersistentStoreCoordinator", code: 1, description: "Failed to create NSPersistentStoreCoordinator", reason: "Could not merge a ManagedObject model in \(realBundle)", underlyingError: nil)
        }
    }
    
    throw error
}

extension NSPersistentStoreCoordinator
{
    public convenience init(modelName: String? = nil, inBundle bundle: NSBundle? = nil, storeType: NSPersistentStoreType = .SQLite) throws
    {
        var error: NSError! = NSError(domain: "Migrator", code: 0, userInfo: nil)
        do {
            let model = try managedObjectModelWithName(modelName, inBundle: bundle)
            self.init(managedObjectModel: model)
            
            var internalError: NSError? = nil
            
            do {
                try self.addPersistentStoreWithType(
                                storeType.persistentStoreType,
                                configuration: nil,
                                URL: storeType.persistentStoreFileURL(modelName ?? "store"),
                                options: nil)
            } catch let error1 as NSError {
                internalError = error1
                error = NSError(domain: "NSPersistentStoreCoordinator", code: 3, description: "Failed to create NSPersistentStoreCoordinator", reason: "Could not create Persistent Store", underlyingError: internalError)
            }
            
            return
        } catch let error1 as NSError {
            error = error1
        }
        
//        //Dummy init to satisfy compiler
//        self.init(managedObjectModel: NSManagedObjectModel())
//        
        throw error
    }
}

