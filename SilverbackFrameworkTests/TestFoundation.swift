//
//  TestFoundation.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 20/04/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import XCTest

class TestFoundation: XCTestCase
{
    func testUnwrap()
    {
        let int = 20
        
        XCTAssertEqual(unwrap(int, 10), 20)

        let noInt : Int? = nil
        
        XCTAssertEqual(unwrap(noInt, 10), 10)
    }
}
