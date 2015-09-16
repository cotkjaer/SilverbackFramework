//
//  FloatTest.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 20/04/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import XCTest

class FloatTest: XCTestCase
{
    func testAbs()
    {
        XCTAssertGreaterThan(Float(-1.0).abs, Float(0))
    }
    
    func testSqrt()
    {
        XCTAssertEqual(Float(4.0).sqrt, Float(2))
    }
    
    func testFloor()
    {
        XCTAssertEqual(Float(123.99).floor, Float(123))
    }
    
    func testCeil()
    {
        XCTAssertEqual(Float(0.09).ceil, Float(1))
        XCTAssertEqual(Float(-0.09).ceil, Float(0))
    }
    
    func testRound()
    {
        XCTAssertEqual(Float(0.50).round, Float(1))
        XCTAssertEqual(Float(0.49).round, Float(0))
    }
    
    func testClamp()
    {
        XCTAssertEqualWithAccuracy(Float(0.25).clamp(0, 0.50), Float(0.25), accuracy: 0.001)
        XCTAssertEqualWithAccuracy(Float(2).clamp(0, 0.50), Float(0.5), accuracy: 0.001)
        XCTAssertEqualWithAccuracy(Float(-2).clamp(0, 0.50), Float(0), accuracy: 0.001)
    }
    
    func testRandom()
    {
        let rand = Float.random(lower:1.0, upper:0.5)
        
        XCTAssertGreaterThan(rand, Float(0.4999))
        XCTAssertLessThan(rand, Float(1.0))
        
        XCTAssertGreaterThan(Float.random(), Float(-0.001))
        
    }
}
