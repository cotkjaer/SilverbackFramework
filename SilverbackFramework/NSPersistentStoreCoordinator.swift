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
    
    private func persistentStoreFileURL(modelName: String, fileExtension: String, error: NSErrorPointer = nil) -> NSURL?
    {
        if let documentsDirectoryURL = NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory,
            inDomain: .UserDomainMask, appropriateForURL: nil, create: true, error: error)
        {
            return documentsDirectoryURL.URLByAppendingPathComponent(modelName + "." + fileExtension)
        }
        
        return nil
    }
    
    internal func persistentStoreFileURL(modelName: String, error: NSErrorPointer = nil) -> NSURL?
    {
        switch self
        {
        case .SQLite:
            return persistentStoreFileURL(modelName, fileExtension: "sqlite")
        case .InMemory:
            return nil
        case .Binary:
            return persistentStoreFileURL(modelName, fileExtension: "sqlite")
        }
    }
}

func managedObjectModelWithName(name: String?, inBundle bundle: NSBundle?, error: NSErrorPointer = nil) -> NSManagedObjectModel?
{
    let realBundle = (bundle ?? NSBundle.mainBundle())
    
    if let modelName = name
    {
        if let modelURL = realBundle.URLForResource(modelName, withExtension: "momd")
        {
            if let model = NSManagedObjectModel(contentsOfURL: modelURL)
            {
                return model
            }
            else if error != nil
            {
                error.memory = NSError(domain: "NSPersistentStoreCoordinator", code: 2, description: "Failed to create NSPersistentStoreCoordinator", reason: "Could not create ManagedObject model from URL \(modelURL)", underlyingError: nil)
            }
        }
        else if error != nil
        {
            error.memory = NSError(domain: "NSPersistentStoreCoordinator", code: 1, description: "Failed to create NSPersistentStoreCoordinator", reason: "Could not find ManagedObject model called \(modelName) in \(realBundle)", underlyingError: nil)
        }
    }
    else
    {
        if let model = NSManagedObjectModel.mergedModelFromBundles([realBundle])
        {
            return model
        }
        else if error != nil
        {
            error.memory = NSError(domain: "NSPersistentStoreCoordinator", code: 1, description: "Failed to create NSPersistentStoreCoordinator", reason: "Could not merge a ManagedObject model in \(realBundle)", underlyingError: nil)
        }
    }
    
    return nil
}

extension NSPersistentStoreCoordinator
{
    public convenience init?(modelName: String? = nil, inBundle bundle: NSBundle? = nil, storeType: NSPersistentStoreType = .SQLite, error: NSErrorPointer = nil)
    {
        if let model = managedObjectModelWithName(modelName, inBundle: bundle, error: error)
        {
            self.init(managedObjectModel: model)
            
            var internalError: NSError? = nil
            
            if self.addPersistentStoreWithType(
                storeType.persistentStoreType,
                configuration: nil,
                URL: storeType.persistentStoreFileURL(modelName ?? "store"),
                options: nil,
                error: &internalError) == nil
            {
                if error != nil
                {
                    error.memory = NSError(domain: "NSPersistentStoreCoordinator", code: 3, description: "Failed to create NSPersistentStoreCoordinator", reason: "Could not create Persistent Store", underlyingError: internalError)
                }
            }
            
            return
        }
        
        //Dummy init to satisfy compiler
        self.init(managedObjectModel: NSManagedObjectModel())
        
        return nil
    }
}

