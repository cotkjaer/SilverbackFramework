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
    public convenience init(modelName: String? = nil, inBundle: NSBundle? = nil, storeType: NSPersistentStoreType = .SQLite) throws
    {
        do
        {
            let coordinator = try NSPersistentStoreCoordinator(modelName:modelName, inBundle: inBundle ?? NSBundle.mainBundle(), storeType: storeType)
            
            self.init(persistentStoreCoordinator: coordinator)
        }
        catch let error as NSError
        {
            throw error
        }
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
        if let _ = objectRegisteredForID(object.objectID)
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
        if let entityDescription = NSEntityDescription.entityForName(type.baseClassName, inManagedObjectContext: self)
        {
            return entityDescription
        }
        
        return nil
    }
    
    public func insert<T: NSManagedObject>(type: T.Type) -> T?
    {
        if let entityDescription = self.entityDescriptionFor(type)
        {
            return type.init(entity: entityDescription, insertIntoManagedObjectContext: self)
        }
        
        return nil
    }
    
    private func executeFetchRequestLogErrors(request: NSFetchRequest) -> [AnyObject]?
    {
        let result: [AnyObject]?
        
        do
        {
            result = try self.executeFetchRequest(request)
        }
        catch let error as NSError
        {
            debugPrint("Error : \(error)")
            result = nil
        }
        
        return result
    }

    public func fetch<T: NSManagedObject>(type: T.Type, predicate:NSPredicate? = nil) -> [T]?
    {
        let fetchRequest = NSFetchRequest(entityName: type.baseClassName)

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
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = 1
        
        if let result = self.executeFetchRequestLogErrors(fetchRequest) as? [T]
        {
            return result.last
        }
        
        return nil
    }
    
    public func any<T: NSManagedObject>(type: T.Type, format: String, _ arguments: AnyObject...) -> T?
    {
        let predicate = NSPredicate(format: format, argumentArray: arguments)
        
        return any(type, predicate: predicate)
    }
    
    public func unique<T: NSManagedObject>(type: T.Type, with dictionary: [String : AnyObject]) -> T
    {
        var predicates = Array<NSPredicate>()
        
        for (key, value) in dictionary
        {
            predicates.append(NSPredicate(format: "%K = %@", argumentArray: [key, value]))
        }
        
        if let res = any(type, predicate: NSCompoundPredicate(type: .AndPredicateType, subpredicates: predicates))
        {
            return res
        }
        else if let res = insert(type)
        {
            for (key, value) in dictionary
            {
                (res as NSManagedObject).setValue(value, forKey: key)
            }
            
            return res
        }
        
        preconditionFailure("Unable to either find or insert \(type) with \(predicates.description)")
    }
}