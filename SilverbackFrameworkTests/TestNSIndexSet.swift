//
//  TestNSIndexSet.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 20/04/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import XCTest

class TestNSIndexSet: XCTestCase
{
    func testInitArray()
    {
        let indicies = [0,3,8]
        
        let indexSet : NSIndexSet = NSIndexSet(indicies:indicies)
        
        XCTAssertNotNil(indexSet)
        XCTAssert(indexSet.count == 3)
        XCTAssert(indexSet.containsIndex(3))
        XCTAssert(!indexSet.containsIndex(2))
        
    }
}
