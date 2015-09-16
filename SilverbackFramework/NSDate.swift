//
//  NSDate.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 20/04/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import Foundation

extension NSDate
{
    public func isOnSameDayAs(date:NSDate) -> Bool
    {
        return NSCalendar.currentCalendar().isDate(self, inSameDayAsDate: date)
    }
}

extension NSDate
{
    public var daysInMonth : Int
        {
            return datesInMonth.length
    }
    
    public var datesInMonth: NSRange
        {
            let calendar = NSCalendar.currentCalendar()
            let range = calendar.rangeOfUnit(NSCalendarUnit.Day, inUnit:NSCalendarUnit.Month, forDate: self)
            
            return range
    }
    
    // MARK: Components
    
    public var year : Int { return getComponent(.Year) }
    
    public var month : Int { return getComponent(.Month) }
    
    public var weekday : Int { return getComponent(.Weekday) }
    
    public var weekMonth : Int { return getComponent(.WeekOfMonth) }

    public var weekYear : Int { return getComponent(.WeekOfYear) }
    
    public var day : Int { return getComponent(.Day) }
    
    public var hour : Int { return getComponent(.Hour) }
    
    public var minute : Int { return getComponent(.Minute) }
    
    public var second : Int { return getComponent(.Second) }
    
    /**
    Returns the value of the NSDate component
    
    - parameter component: NSCalendarUnit
    - returns: the value of the component in the current NSCalendar
    */
    public func getComponent(component : NSCalendarUnit) -> Int
    {
        return NSCalendar.currentCalendar().component(component, fromDate: self)
        
//        let calendar = NSCalendar.currentCalendar()
//        let components = calendar.components(component, fromDate: self)
//        
//        return components.valueForComponent(component)
    }
    
    /**
    Returns a new NSDate object representing the date calculated by adding the amount specified to self date
    
    - parameter seconds: number of seconds to add
    - parameter minutes: number of minutes to add
    - parameter hours: number of hours to add
    - parameter days: number of days to add
    - parameter weeks: number of weeks to add
    - parameter months: number of months to add
    - parameter years: number of years to add
    - returns: the NSDate computed
    */
    public func add(seconds: Int = 0, minutes: Int = 0, hours: Int = 0, days: Int = 0, weeks: Int = 0, months: Int = 0, years: Int = 0) -> NSDate
    {
        let calendar = NSCalendar.currentCalendar()
        
        var date : NSDate! = calendar.dateByAddingUnit(.Second, value: seconds, toDate: self, options: [])
        date = calendar.dateByAddingUnit(.Minute, value: minutes, toDate: date, options: [])
        date = calendar.dateByAddingUnit(.Day, value: days, toDate: date, options: [])
        date = calendar.dateByAddingUnit(.Hour, value: hours, toDate: date, options: [])
        date = calendar.dateByAddingUnit(.WeekOfMonth, value: weeks, toDate: date, options: [])
        date = calendar.dateByAddingUnit(.Month, value: months, toDate: date, options: [])
        date = calendar.dateByAddingUnit(.Year, value: years, toDate: date, options: [])
        return date
    }
}


// MARK: Operators

public func + (date: NSDate, timeInterval: Int) -> NSDate {
    return date + NSTimeInterval(timeInterval)
}

public func - (date: NSDate, timeInterval: Int) -> NSDate {
    return date - NSTimeInterval(timeInterval)
}

public func += (inout date: NSDate, timeInterval: Int) {
    date = date + timeInterval
}

public func -= (inout date: NSDate, timeInterval: Int) {
    date = date - timeInterval
}

public func + (date: NSDate, timeInterval: Double) -> NSDate {
    return date.dateByAddingTimeInterval(NSTimeInterval(timeInterval))
}

public func - (date: NSDate, timeInterval: Double) -> NSDate {
    return date.dateByAddingTimeInterval(NSTimeInterval(-timeInterval))
}

public func += (inout date: NSDate, timeInterval: Double) {
    date = date + timeInterval
}

public func -= (inout date: NSDate, timeInterval: Double) {
    date = date - timeInterval
}

public func - (date: NSDate, otherDate: NSDate) -> NSTimeInterval {
    return date.timeIntervalSinceDate(otherDate)
}

//MARK: - Equatable

//extension NSDate: Equatable
//{
//}
//
//public func == (lhs: NSDate, rhs: NSDate) -> Bool
//{
//    return lhs.compare(rhs) == NSComparisonResult.OrderedSame
//}

//MARK: - Comparable

extension NSDate: Comparable
{
}

public func < (lhs: NSDate, rhs: NSDate) -> Bool
{
    return lhs.compare(rhs) == NSComparisonResult.OrderedAscending
}

public func > (lhs: NSDate, rhs: NSDate) -> Bool
{
    return lhs.compare(rhs) == NSComparisonResult.OrderedDescending
}


public func >= (lhs: NSDate, rhs: NSDate) -> Bool
{
    return lhs > rhs || lhs == rhs
}

public func <= (lhs: NSDate, rhs: NSDate) -> Bool
{
    return lhs < rhs || lhs == rhs
}

//MARK: - Stridable

extension NSDate: Strideable
{
    public func distanceTo(other: NSDate) -> NSTimeInterval
    {
        return other - self
    }
    
    public func advancedBy(n: NSTimeInterval) -> Self
    {
        return self.dynamicType.init(timeIntervalSinceReferenceDate: self.timeIntervalSinceReferenceDate + n)
    }
}


////MARK: - Is this too obscure?
//
//public func + (date: NSDate, tuple: (value: Int, unit: NSCalendarUnit)) -> NSDate
//{
//    return NSCalendar.currentCalendar().dateByAddingUnit(tuple.unit, value: tuple.value, toDate: date, options: NSCalendarOptions.SearchBackwards)!
//}
//
//public func - (date: NSDate, tuple: (value: Int, unit: NSCalendarUnit)) -> NSDate
//{
//    return NSCalendar.currentCalendar().dateByAddingUnit(tuple.unit, value: -tuple.value, toDate: date, options: NSCalendarOptions.SearchBackwards)!
//}
//
//public func += (inout date: NSDate, tuple: (value: Int, unit: NSCalendarUnit))
//{
//    date = date + tuple
//}
//
//public func -= (inout date: NSDate, tuple: (value: Int, unit: NSCalendarUnit))
//{
//    date =  date - tuple
//}
//
//extension Int
//{
//    public var second: (Int, NSCalendarUnit) { return (self, NSCalendarUnit.CalendarUnitSecond) }
//    
//    public var minute: (Int, NSCalendarUnit) { return (self, NSCalendarUnit.CalendarUnitMinute) }
//
//    public var hour: (Int, NSCalendarUnit) { return (self, NSCalendarUnit.CalendarUnitHour) }
//    
//    public var day: (Int, NSCalendarUnit) { return (self, NSCalendarUnit.CalendarUnitDay) }
//
//    public var week: (Int, NSCalendarUnit) { return (self, NSCalendarUnit.CalendarUnitWeekOfYear) }
//    
//    public var month: (Int, NSCalendarUnit) { return (self, NSCalendarUnit.CalendarUnitMonth) }
//    
//    public var year: (Int, NSCalendarUnit) { return (self, NSCalendarUnit.CalendarUnitYear) }
//}

