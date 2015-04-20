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
    func isOnSameDayAs(date:NSDate) -> Bool
    {
        return NSCalendar.currentCalendar().isDate(self, inSameDayAsDate: date)
    }
}

func == (date1: NSDate, date2: NSDate) -> Bool
{
    return date1.compare(date2) == NSComparisonResult.OrderedSame
}

func > (date1: NSDate, date2: NSDate) -> Bool
{
    return date1.compare(date2) == NSComparisonResult.OrderedDescending
}

func < (date1: NSDate, date2: NSDate) -> Bool
{
    return date1.compare(date2) == NSComparisonResult.OrderedAscending
}

func >= (date1: NSDate, date2: NSDate) -> Bool
{
    return date1 > date2 || date1 == date2
}

func <= (date1: NSDate, date2: NSDate) -> Bool
{
    return date1 < date2 || date1 == date2
}


extension NSDate
{
    var weekday: Int
        {
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components(.CalendarUnitWeekday, fromDate: self)
            let weekDay = components.weekday
            return weekDay
    }
    
    var daysInMonth : Int
        {
            return datesInMonth.length
    }
    
    var datesInMonth: NSRange
        {
            let calendar = NSCalendar.currentCalendar()
            let range = calendar.rangeOfUnit(NSCalendarUnit.CalendarUnitDay, inUnit:NSCalendarUnit.CalendarUnitMonth, forDate: self)
            
            return range
    }
    
    var year : Int
        {
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components(.CalendarUnitYear, fromDate: self)
            return components.year
    }
}

//MARK: - Is this too obscure?

func + (date: NSDate, tuple: (value: Int, unit: NSCalendarUnit)) -> NSDate
{
    return NSCalendar.currentCalendar().dateByAddingUnit(tuple.unit, value: tuple.value, toDate: date, options: NSCalendarOptions.SearchBackwards)!
}

func - (date: NSDate, tuple: (value: Int, unit: NSCalendarUnit)) -> NSDate
{
    return NSCalendar.currentCalendar().dateByAddingUnit(tuple.unit, value: -tuple.value, toDate: date, options: NSCalendarOptions.SearchBackwards)!
}

func += (inout date: NSDate, tuple: (value: Int, unit: NSCalendarUnit))
{
    date = date + tuple
}

func -= (inout date: NSDate, tuple: (value: Int, unit: NSCalendarUnit))
{
    date =  date - tuple
}

extension Int
{
    var hour: (Int, NSCalendarUnit) { return (self, NSCalendarUnit.CalendarUnitHour) }
    
    var day: (Int, NSCalendarUnit) { return (self, NSCalendarUnit.CalendarUnitDay) }
    
    var month: (Int, NSCalendarUnit) { return (self, NSCalendarUnit.CalendarUnitMonth) }
    
    var year: (Int, NSCalendarUnit) { return (self, NSCalendarUnit.CalendarUnitYear) }
    
}

