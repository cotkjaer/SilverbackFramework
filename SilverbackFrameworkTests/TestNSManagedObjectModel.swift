//
//  TestNSManagedObjectModel.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 22/04/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import CoreData
import XCTest

class TestNSManagedObjectModel: XCTestCase {

    let bundle = NSBundle(forClass: TestCoreDataStore.self)
    
    let modelName = "SilverbackFramework"

    func testInit()
    {
        XCTAssertNotNil(NSManagedObjectModel(modelName: modelName, inBundle: bundle))
        
        XCTAssertNil(NSManagedObjectModel(modelName: modelName + "foo", inBundle: bundle))
    }
}
