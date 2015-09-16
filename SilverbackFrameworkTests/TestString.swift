//
//  TestString.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 20/04/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import XCTest

class TestString: XCTestCase
{
    func testCharacterSubscript()
    {
        XCTAssertEqual("Character"[2], Character("a"))
        XCTAssertNotEqual("Character"[0], Character("c"))
    }

    func testStringSubscript()
    {
        XCTAssertEqual("Character"[2], String("a"))
        XCTAssertNotEqual("Character"[0], String("c"))
    }

    func testStringSubscriptRange()
    {
        XCTAssertEqual("Character"[2...4], String("ara"))
        XCTAssertEqual("Character"[0..<4], String("Char"))
    }
    
    func testUppercaseFirstLetter()
    {
        XCTAssertNil("".uppercaseFirstLetter)
        XCTAssertNotNil("x".uppercaseFirstLetter)
        
        XCTAssert("x".uppercaseFirstLetter == "X")
        XCTAssert("X".uppercaseFirstLetter == "X")
        XCTAssert("1".uppercaseFirstLetter == "1")
    }
}
