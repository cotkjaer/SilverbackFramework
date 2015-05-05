//
//  Random.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 20/04/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import Foundation
import UIKit

/**
Arc Random for Double and Float
*/
public func arc4random <T: IntegerLiteralConvertible> (type: T.Type) -> T
{
    var r: T = 0
    
    arc4random_buf(&r, sizeof(T))
//    arc4random_buf(&r, UInt(sizeof(T)))
    return r
}


//public extension Int
//{
//    /**
//    Create a random num Int
//    :param: lower number Int
//    :param: upper number Int
//    :return: random number Int
//    */
//    public static func random (#lower: Int , upper: Int) -> Int {
//        return lower + Int(arc4random_uniform(upper - lower + 1))
//    }
//}

extension UInt64
{
    static func random(lower: UInt64 = min, upper: UInt64 = max) -> UInt64
    {
        var m: UInt64
        let u = upper - lower
        var r = arc4random(UInt64)
        
        if u > UInt64(Int64.max)
        {
            m = 1 + ~u
        } else
        {
            m = ((max - (u * 2)) + 1) % u
        }
        
        while r < m
        {
            r = arc4random(UInt64)
        }
        
        return (r % u) + lower
    }
}

extension Int64
{
    static func random(lower: Int64 = min, upper: Int64 = max) -> Int64
    {
        let (s, overflow) = Int64.subtractWithOverflow(upper, lower)
        let u = overflow ? UInt64.max - UInt64(~s) : UInt64(s)
        let r = UInt64.random(upper: u)
        
        if r > UInt64(Int64.max)
        {
            return Int64(r - (UInt64(~lower) + 1))
        } else
        {
            return Int64(r) + lower
        }
    }
}

extension UInt32
{
    static func random(lower: UInt32 = min, upper: UInt32 = max) -> UInt32
    {
        return arc4random_uniform(upper - lower) + lower
    }
}

extension Int32
{
    static func random(lower: Int32 = min, upper: Int32 = max) -> Int32
    {
        let r = arc4random_uniform(UInt32(Int64(upper) - Int64(lower)))
        return Int32(Int64(r) + Int64(lower))
    }
}

extension UInt
{
    static func random(lower: UInt = min, upper: UInt = max) -> UInt
    {
        switch (__WORDSIZE)
        {
        case 32: return UInt(UInt32.random(lower: UInt32(lower), upper: UInt32(upper)))
        case 64: return UInt(UInt64.random(lower: UInt64(lower), upper: UInt64(upper)))
        default: return lower
        }
    }
}


public extension Double
{
    /**
    Create a random num Double
    :param: lower number Double
    :param: upper number Double
    :return: random number Double
    */
    public static func random(#lower: Double, upper: Double) -> Double
    {
        let r = Double(arc4random(UInt64)) / Double(UInt64.max)
        return (r * (upper - lower)) + lower
    }
}


