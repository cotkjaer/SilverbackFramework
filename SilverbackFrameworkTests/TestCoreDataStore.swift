//
//  TestCoreDataStore.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 21/04/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import UIKit
import XCTest
import CoreData

class TestCoreDataStore: XCTestCase
{
    var optionalStore : CoreDataStore?
    
    let bundle = NSBundle(forClass: TestCoreDataStore.self)
    
    let modelName = "SilverbackFramework"

    override func setUp()
    {
        optionalStore = CoreDataStore(modelName: modelName, inBundle: bundle, storeType: .InMemory)
    }
    
    func testCoreDataStoreInit()
    {
        XCTAssertNotNil(CoreDataStore(modelName: modelName, inBundle: bundle, storeType: .InMemory))
        XCTAssertNotNil(CoreDataStore(modelName: modelName, inBundle: bundle, storeType: .SQLite))
        XCTAssertNotNil(CoreDataStore(modelName: modelName, inBundle: bundle, storeType: .Binary))
    }
}
