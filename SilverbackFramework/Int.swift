//
//  Int.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 20/04/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import Foundation

public extension Int
{
    /**
    Calls function self times.
    
    - parameter function: Function to call
    */
    func times <T> (function: Void -> T)
    {
        for _ in (0..<self)
        {
            function()
        }
    }
    
    /**
    Calls function self times.
    
    - parameter function: Function to call
    */
    func times (function: Void -> Void)
    {
        for _ in (0..<self)
        {
            function()
        }
    }
    
    /**
    Calls function self times passing a value from 0 to self on each call.
    
    - parameter function: Function to call
    */
    func times <T> (function: (Int) -> T)
    {
        for index in (0..<self)
        {
            function(index)
        }
    }
    
    /**
    Checks if a number is even.
    
    - returns: true if self is even
    */
    var even: Bool
        {
            return (self % 2) == 0
    }
    
    /**
    Checks if a number is odd.
    
    - returns: true if self is odd
    */
    var odd: Bool
        {
            return !even
    }
    
    /**
    Iterates function, passing in integer values from self up to and including limit.
    
    - parameter limit: Last value to pass
    - parameter function: Function to invoke
    */
    func upTo(limit: Int, function: (Int) -> ())
    {
        
        if limit < self
        {
            return
        }
        
        for index in (self...limit)
        {
            function(index)
        }
    }
    
    /**
    Iterates function, passing in integer values from self down to and including limit.
    
    - parameter limit: Last value to pass
    - parameter function: Function to invoke
    */
    func downTo(limit: Int, function: (Int) -> ())
    {
        if limit > self
        {
            return
        }
        
        for index in Array(Array(limit...self).reverse())
        {
            function(index)
        }
    }
    
    /**
    Clamps self to a specified range.
    
    - parameter range: Clamping range
    - returns: Clamped value
    */
    func clamp(range: Range<Int>) -> Int
    {
        return clamp(range.startIndex, range.endIndex - 1)
    }
    
    /**
    Clamps self to a specified range.
    
    - parameter lower: Lower bound
    - parameter upper: Upper bound
    - returns: Clamped value
    */
    func clamp(lower: Int, _ upper: Int) -> Int
    {
        return Swift.max(lower, Swift.min(upper, self))
    }
    
    /**
    Checks if self is included a specified range.
    
    - parameter range: Range
    - parameter string: If true, "<" is used for comparison
    - returns: true if in range
    */
    func isIn(range: Range<Int>, strict: Bool = false) -> Bool
    {
        if strict
        {
            return range.startIndex < self && self < range.endIndex - 1
        }
        
        return range.startIndex <= self && self <= range.endIndex - 1
    }
    
    /**
    Checks if self is included in a closed interval.
    
    - parameter interval: Interval to check
    - returns: true if in the interval
    */
    func isIn(interval: ClosedInterval<Int>) -> Bool
    {
        return interval.contains(self)
    }
    
    /**
    Checks if self is included in an half open interval.
    
    - parameter interval: Interval to check
    - returns: true if in the interval
    */
    func isIn (interval: HalfOpenInterval<Int>) -> Bool
    {
        return interval.contains(self)
    }
    
    /**
    Returns an [Int] containing the digits in self.
    
    :return: Array of digits
    */
    var digits: [Int]
        {
            var result = [Int]()
            
            for char in String(self).characters
            {
                let string = String(char)
                if let toInt = Int(string)
                {
                    result.append(toInt)
                }
            }
            
            return result
    }
    
    /**
    Absolute value.
    
    - returns: abs(self)
    */
    var abs: Int
        {
            return Swift.abs(self)
    }
    
    /**
    Greatest common divisor of self and n.
    
    - parameter n:
    - returns: GCD
    */
    func gcd(n: Int) -> Int
    {
        return n == 0 ? self : n.gcd(self % n)
    }
    
    /**
    Least common multiple of self and n
    
    - parameter n:
    - returns: LCM
    */
    func lcm(n: Int) -> Int
    {
        return (self * n).abs / gcd(n)
    }
    
    /**
    Computes the factorial of self
    
    - returns: Factorial
    */
    var factorial: Int
        {
            return self == 0 ? 1 : self * (self - 1).factorial
    }
    
    /**
    Random integer between lower and upper (inclusive).
    
    - parameter lower: Minimum value to return
    - parameter upper: Maximum value to return
    - returns: Random integer
    */
    static func random(lower lower: Int = min, upper: Int = max) -> Int
    {
//        switch (__WORDSIZE)
//        {
//        case 32: return Int(Int32.random(Int32(lower), upper: Int32(upper)))
//        case 64: 
        return Int(Int64.random(Int64(lower), upper: Int64(upper)))
//        }
    }
}

public extension Int
{
    public func format(format: String? = "") -> String
    {
        return String(format: "%\(format)d", self)
    }
}

/**
NSTimeInterval conversion extensions
*/
public extension Int
{
    var years: NSTimeInterval
        { return 365 * self.days }
    
    var year: NSTimeInterval
        { return self.years }
    
    var weeks: NSTimeInterval
        { return 7 * self.days }
    
    var week: NSTimeInterval
        { return self.weeks }
    
    var days: NSTimeInterval
        { return 24 * self.hours }
    
    var day: NSTimeInterval
        { return self.days }
    
    var hours: NSTimeInterval
        { return 60 * self.minutes }
    
    var hour: NSTimeInterval
        { return self.hours }
    
    var minutes: NSTimeInterval
        { return 60 * self.seconds }
    
    var minute: NSTimeInterval
        { return self.minutes }
    
    var seconds: NSTimeInterval
        { return NSTimeInterval(self) }
    
    var second: NSTimeInterval
        { return self.seconds }
}
