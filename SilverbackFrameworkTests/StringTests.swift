//
//  StringTests.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 03/09/15.
//  Copyright © 2015 Christian Otkjær. All rights reserved.
//

import XCTest

class StringTests: XCTestCase
{
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testStringUnsignedIntegerRadixUppercasePaddedToSize()
    {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let e8 = String(UInt8(232), radix: 16, paddedToSize: 2)
        
        XCTAssertEqual(e8, "e8")

        let _11101000 = String(UInt8(232), radix: 2, paddedToSize: 8)

        XCTAssertEqual(_11101000, "11101000")

        let _x = String(UInt(3210), radix: 10, uppercase: true, paddedToSize: 5)
        
        XCTAssertEqual(_x, "03210")

    }
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measureBlock {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}
