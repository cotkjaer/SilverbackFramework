//
//  CGFloatTest.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 20/04/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import XCTest
import CoreGraphics

class CGFloatTest: XCTestCase
{
    func testEqualToWithin()
    {
        let x1 : CGFloat = 1.0
        let x2 : CGFloat = 1.01
        
        XCTAssert(equalsWithin(CGFloat(0.02), x1, to: x2))
    }
}
