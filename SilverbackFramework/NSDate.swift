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
            let range = calendar.rangeOfUnit(NSCalendarUnit.CalendarUnitDay, inUnit:NSCalendarUnit.CalendarUnitMonth, forDate: self)
            
            return range
    }
    
    // MARK: Components
    
    public var year : Int { return getComponent(.CalendarUnitYear) }
    
    public var month : Int { return getComponent(.CalendarUnitMonth) }
    
    public var weekday : Int { return getComponent(.CalendarUnitWeekday) }
    
    public var weekMonth : Int { return getComponent(.CalendarUnitWeekOfMonth) }

    public var weekYear : Int { return getComponent(.CalendarUnitWeekOfYear) }
    
    public var day : Int { return getComponent(.CalendarUnitDay) }
    
    public var hour : Int { return getComponent(.CalendarUnitHour) }
    
    public var minute : Int { return getComponent(.CalendarUnitMinute) }
    
    public var second : Int { return getComponent(.CalendarUnitSecond) }
    
    /**
    Returns the value of the NSDate component
    
    :param: component NSCalendarUnit
    :returns: the value of the component
    */
    
    public func getComponent (component : NSCalendarUnit) -> Int
    {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(component, fromDate: self)
        
        return components.valueForComponent(component)
    }
    
    /**
    Returns a new NSDate object representing the date calculated by adding the amount specified to self date
    
    :param: seconds number of seconds to add
    :param: minutes number of minutes to add
    :param: hours number of hours to add
    :param: days number of days to add
    :param: weeks number of weeks to add
    :param: months number of months to add
    :param: years number of years to add
    :returns: the NSDate computed
    */
    public func add(seconds: Int = 0, minutes: Int = 0, hours: Int = 0, days: Int = 0, weeks: Int = 0, months: Int = 0, years: Int = 0) -> NSDate
    {
        var calendar = NSCalendar.currentCalendar()
        
        var date : NSDate! = calendar.dateByAddingUnit(.CalendarUnitSecond, value: seconds, toDate: self, options: nil)
        date = calendar.dateByAddingUnit(.CalendarUnitMinute, value: minutes, toDate: date, options: nil)
        date = calendar.dateByAddingUnit(.CalendarUnitDay, value: days, toDate: date, options: nil)
        date = calendar.dateByAddingUnit(.CalendarUnitHour, value: hours, toDate: date, options: nil)
        date = calendar.dateByAddingUnit(.CalendarUnitWeekOfMonth, value: weeks, toDate: date, options: nil)
        date = calendar.dateByAddingUnit(.CalendarUnitMonth, value: months, toDate: date, options: nil)
        date = calendar.dateByAddingUnit(.CalendarUnitYear, value: years, toDate: date, options: nil)
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

extension NSDate: Equatable
{
}

public func == (lhs: NSDate, rhs: NSDate) -> Bool
{
    return lhs.compare(rhs) == NSComparisonResult.OrderedSame
}

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
        return self.dynamicType(timeIntervalSinceReferenceDate: self.timeIntervalSinceReferenceDate + n)
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

