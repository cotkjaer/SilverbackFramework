//
//  CoreDataStack.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 21/04/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import CoreData

/// Sets up a CoreData Stack as described in http://floriankugler.com/blog/2013/4/29/concurrent-core-data-stack-performance-shootout 3rd alternative
public class CoreDataStack
{
    private let store: CoreDataStore!
    
    /// main thread context
    public let mainContext: NSManagedObjectContext!
    
    /// background thread context (could be made lazy, as you do not always need it, but it is keept as eager, for brevity)
    public let backgroundContext: NSManagedObjectContext!
    
    public required init(store:CoreDataStore)
    {
        self.store = store
        
        mainContext = NSManagedObjectContext(persistentStoreCoordinator: store.persistentStoreCoordinator, concurrencyType: .MainQueueConcurrencyType)
        
        backgroundContext = NSManagedObjectContext(persistentStoreCoordinator:store.persistentStoreCoordinator, concurrencyType: .PrivateQueueConcurrencyType)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("contextDidSaveContext:"), name: NSManagedObjectContextDidSaveNotification, object: nil)
    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // save NSManagedObjectContext
//    func saveContext(context: NSManagedObjectContext)
//    {
//        var error: NSError? = nil
//        
//        if context.hasChanges && !context.save(&error)
//        {
//            // Replace this implementation with code to handle the error appropriately.
//            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            NSLog("Unresolved error \(error), \(error!.userInfo)")
//            abort()
//        }
//    }
//    
//    func saveContext () {
//        self.saveContext( self.backgroundContext )
//    }
    
    // call back function by saveContext, support multi-thread
    func contextDidSaveContext(notification: NSNotification)
    {
        if let context = notification.object as? NSManagedObjectContext
        {
            if context === self.mainContext
            {
                NSLog("******** Saved main Context in this thread")
                
                self.backgroundContext.performBlock
                    {
                        self.backgroundContext.mergeChangesFromContextDidSaveNotification(notification)
                }
            }
            else if context === self.backgroundContext
            {
                NSLog("******** Saved background Context in this thread")
                self.mainContext.performBlock
                    {
                        self.mainContext.mergeChangesFromContextDidSaveNotification(notification)
                }
            }
            else
            {
                NSLog("******** Saved Context in other thread")
                self.backgroundContext.performBlock
                    {
                        self.backgroundContext.mergeChangesFromContextDidSaveNotification(notification)
                }
                self.mainContext.performBlock
                    {
                        self.mainContext.mergeChangesFromContextDidSaveNotification(notification)
                }
            }
        }
    }
}
