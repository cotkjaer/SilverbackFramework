//
//  NSManagedObjectContext.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 21/04/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import CoreData

extension NSManagedObjectContext
{
    public convenience init?(modelName: String, inBundle: NSBundle? = nil, storeType: NSPersistentStoreType = .SQLite, error: NSErrorPointer = nil)
    {
        if let coordinator = NSPersistentStoreCoordinator(modelName:modelName, inBundle: inBundle ?? NSBundle.mainBundle(), storeType: storeType, error:error)
        {
            self.init(persistentStoreCoordinator: coordinator)
            
            return
        }
        
        self.init()
        
        return nil
    }
    
    public convenience init(
        persistentStoreCoordinator: NSPersistentStoreCoordinator,
        concurrencyType: NSManagedObjectContextConcurrencyType = .MainQueueConcurrencyType)
    {
        self.init(concurrencyType: concurrencyType)
        self.persistentStoreCoordinator = persistentStoreCoordinator
    }
    
    public convenience init(
        parentContext: NSManagedObjectContext,
        concurrencyType: NSManagedObjectContextConcurrencyType? = nil)
    {
        let ct = concurrencyType ?? parentContext.concurrencyType
        
        self.init(concurrencyType: ct)
        self.parentContext = parentContext
    }
    
    public func childContext(concurrencyType: NSManagedObjectContextConcurrencyType = .MainQueueConcurrencyType) -> NSManagedObjectContext
    {
        return NSManagedObjectContext(parentContext: self, concurrencyType: concurrencyType)
    }
    
    public func objectInChildContext<T: NSManagedObject>(object: T, concurrencyType: NSManagedObjectContextConcurrencyType? = nil) -> (NSManagedObjectContext, T)?
    {
        if let registeredObject = objectRegisteredForID(object.objectID)
        {
            let context = NSManagedObjectContext(parentContext: self, concurrencyType: concurrencyType)
            
            if let childObject = context.objectWithID(object.objectID) as? T
            {
                return (context, childObject)
            }
        }
        
        return nil
    }
    
    private func entityDescriptionFor<T: NSManagedObject>(type: T.Type) -> NSEntityDescription?
    {
        if let entityDescription = NSEntityDescription.entityForName(type.baseName(), inManagedObjectContext: self)
        {
            return entityDescription
        }
        
        return nil
    }
    
    public func insert<T: NSManagedObject>(type: T.Type) -> T?
    {
        if let entityDescription = self.entityDescriptionFor(type)
        {
            return type(entity: entityDescription, insertIntoManagedObjectContext: self)
        }
        
        return nil
    }
    
    private func executeFetchRequestLogErrors(request: NSFetchRequest) -> [AnyObject]?
    {
        var error : NSError?
        
        let result = self.executeFetchRequest(request, error: &error)
        
        if error != nil
        {
            println("Error : \(error)")
        }
        
        return result
    }

    public func fetch<T: NSManagedObject>(type: T.Type, predicate:NSPredicate? = nil) -> [T]?
    {
        let fetchRequest = NSFetchRequest(entityName: type.baseName())

        fetchRequest.predicate = predicate ?? NSPredicate(value: true)
        
        if let result = self.executeFetchRequestLogErrors(fetchRequest) as? [T]
        {
            return result
        }
        
        return nil
    }

    /// returns all entities with the given type
    public func all<T: NSManagedObject>(type: T.Type) -> [T]?
    {
        return fetch(T.self, predicate: NSPredicate(value: true))
    }
    
    public func any<T: NSManagedObject>(type: T.Type, predicate: NSPredicate? = nil) -> T?
    {
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = self.entityDescriptionFor(type)
        fetchRequest.predicate = predicate //NSPredicate(value: true)
        fetchRequest.fetchLimit = 1
        
        if let result = self.executeFetchRequestLogErrors(fetchRequest) as? [T]
        {
            return result.last
        }
        
        return nil
    }
}