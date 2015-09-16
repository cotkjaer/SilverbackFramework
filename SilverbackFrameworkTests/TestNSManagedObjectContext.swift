//
//  TestNSManagedObjectContext.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 22/04/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import CoreData
import XCTest

class TestNSManagedObjectContext: XCTestCase
{
    let modelName = "SilverbackFramework"
    
    let bundle = NSBundle(forClass: TestCoreDataStore.self)
    
    var coordinator : NSPersistentStoreCoordinator!
    
    var context : NSManagedObjectContext!
    
    override func setUp()
    {
        super.setUp()
        
        coordinator = try! NSPersistentStoreCoordinator(modelName: modelName, inBundle: bundle, storeType:.InMemory)
        
        context = NSManagedObjectContext(persistentStoreCoordinator: coordinator, concurrencyType: .MainQueueConcurrencyType)
    }
    
    func testInit()
    {
        XCTAssertNotNil(context)
        
//        
//        XCTAssertNotNil(NSManagedObjectContext(modelName: modelName, inBundle:bundle))
//        
//        XCTAssertNotNil(NSManagedObjectContext(modelName: modelName, inBundle:bundle, storeType: .SQLite))
//
//        XCTAssertNotNil(NSManagedObjectContext(persistentStoreCoordinator: coordinator))
//
//        XCTAssertNotNil(NSManagedObjectContext(parentContext: context))
    }

    func testInsert()
    {
        if let container = context.insert(Container)
        {
            container.name = "Test"
        
            XCTAssertNotNil(container.name)
        }
        else
        {
            XCTFail("Could not insert")
        }
    }

    func testChildContext()
    {
        XCTAssertNotNil(context.childContext(.PrivateQueueConcurrencyType))
        XCTAssertNotNil(context.childContext())
    }
    
    func XCTAssertThrows<T: ErrorType where T: Equatable>(error: T, block: () throws -> ())
    {
        do
        {
            try block()
        }
        catch let e as T
        {
            XCTAssertEqual(e, error)
        }
        catch
        {
            XCTFail("Wrong error")
        }
    }
    
    func testObjects()
    {
        if let container = context.insert(Container)
        {
            container.name = "parent"
            
            XCTAssertNotNil(container.name)
            
//            let cContext = context.childContext()
            
            if let (childContext, childContextContainer) = context.objectInChildContext(container)
            {
                XCTAssertNotNil(childContext)
                
                XCTAssertEqual(childContextContainer.objectID, container.objectID)
                
                childContextContainer.name = "child"
                
                let error: NSError? = nil

                do
                {
                    try childContext.save()
                }
                catch let e as NSError
                {
                    XCTFail("\(e)")
                }
                

                XCTAssertNil(error)

                XCTAssertEqual(container.name, "child")
            }
            else
            
            {
                XCTFail("Could not get same object in child context")

            }
        }
        else
        {
            XCTFail("Could not insert")
        }
        
    }
}
