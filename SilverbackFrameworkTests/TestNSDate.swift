//
//  TestNSDate.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 20/04/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import XCTest

class TestNSDate: XCTestCase
{
    let now = NSDate()
    let aWeekAgo = NSDate().dateByAddingTimeInterval(-60*60*24*7)
    
    func testEquals()
    {
        XCTAssert(now == now)
        XCTAssert(aWeekAgo == aWeekAgo)
        XCTAssert(now != aWeekAgo)
    }

    func testGreaterThan()
    {
        XCTAssert(now > aWeekAgo)
    }
    
    func testGreaterThanOrEqual()
    {
        XCTAssert(now >= aWeekAgo)
        XCTAssert(now >= now)
    }
    
    func testLessThan()
    {
        XCTAssert(aWeekAgo < now)
    }
    
    func testLessThanOrEqual()
    {
        XCTAssert(aWeekAgo <= now)
        XCTAssert(now <= now)
    }

    func testSameDay()
    {
        XCTAssert(now.isOnSameDayAs(now))
        XCTAssert(aWeekAgo.isOnSameDayAs(aWeekAgo))
        XCTAssert(!now.isOnSameDayAs(aWeekAgo))
    }
}
