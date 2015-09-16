//
//  TestNSPersistentStoreCoordinator.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 22/04/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import CoreData
import XCTest

class TestNSPersistentStoreCoordinator: XCTestCase
{
    let bundle = NSBundle(forClass: TestCoreDataStore.self)
    
    let modelName = "SilverbackFramework"
    
    func testInit()
    {
//        XCTAssertNotNil(NSPersistentStoreCoordinator(modelName: modelName, inBundle: bundle, storeType:.SQLite))
//        XCTAssertNotNil(NSPersistentStoreCoordinator(modelName: modelName, inBundle: bundle, storeType:.InMemory))
//        XCTAssertNotNil(NSPersistentStoreCoordinator(modelName: modelName, inBundle: bundle, storeType:.Binary))
//        
//        var error: NSError? = nil
//        
//        XCTAssertNil(NSPersistentStoreCoordinator(modelName: modelName + "foo", inBundle: bundle, error: &error))
//        
//        XCTAssertNotNil(error)
    }
}
