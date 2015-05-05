//
//  TestCoreDataStack.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 22/04/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import CoreData
import XCTest

class TestCoreDataStack: XCTestCase
{
    let bundle = NSBundle(forClass: TestCoreDataStore.self)
    
    let modelName = "SilverbackFramework"

    lazy var store : CoreDataStore = CoreDataStore(modelName: self.modelName, inBundle: self.bundle, storeType: .InMemory)!
    
    func testInit()
    {
        XCTAssertNotNil(store)
        
        let stack = CoreDataStack(store: store)
        
        XCTAssertNotNil(stack.mainContext)
        XCTAssertNotNil(stack.backgroundContext)
    }
    
//    func testCoreDataStoreCreate()
//    {
//        if let context = ?.context
//        {
//            if let container = context.insert(Container)
//            {
//                container.name = "1"
//                
//                for i in 0..<10
//                {
//                    if let element = context.insert(Element)
//                    {
//                        element.id = Int16(i)
//                        element.container = container
//                    }
//                    else
//                    {
//                        XCTFail("Could not create Element")
//                    }
//                }
//                
//                var error: NSError?
//                
//                context.save(&error)
//                
//                XCTAssertNil(error)
//                
//                XCTAssertEqual(container.elements.count, 10)
//                
//                if let allElements = context.all(Element)
//                {
//                    XCTAssertEqual(allElements.count , 10)
//                }
//                else
//                {
//                    XCTFail("could not get all elements")
//                }
//                
//                
//                if let anyElement = context.any(Element)
//                {
//                    
//                }
//                else
//                {
//                    XCTFail("could not get any element")
//                }
//                
//                //                XCTAssert(contains(allElements , anyElement!))
//                
//                //                let anyContainer = context.any(Container)
//                //                XCTAssertNotNil(anyContainer)
//                //                XCTAssertEqual(anyContainer!, container)
//            }
//        }
//        else
//        {
//            XCTFail("Could not create Container")
//        }
//    }
//
//    func testFetch()
//    {
//        //fetch families
//        NSLog(" ======== Fetch ======== ")
//        
//        var error: NSError? = nil
//        var fReq: NSFetchRequest = NSFetchRequest(entityName: "Family")
//        
//        fReq.predicate = NSPredicate(format:"name CONTAINS 'B' ")
//        
//        var sorter: NSSortDescriptor = NSSortDescriptor(key: "name" , ascending: false)
//        fReq.sortDescriptors = [sorter]
//        
//        fReq.returnsObjectsAsFaults = false
//        
//        var result = self.cdh.managedObjectContext!.executeFetchRequest(fReq, error:&error)
//        for resultItem in result! {
//            var familyItem = resultItem as Family
//            NSLog("Fetched Family for \(familyItem.name) ")
//        }
//        XCTAssert(true, "Pass")
//    }
}
