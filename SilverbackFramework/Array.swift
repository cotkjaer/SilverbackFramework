//
//  Array.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 05/05/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import Foundation

public func tail<T>(array: Array<T>?) -> Array<T>?
{
    let count = array?.count ?? 0
    
    if count > 1
    {
        return array![1 ..< count]
    }
    
    return nil
}

public func head<T>(array: Array<T>?) -> T?
{
    return array?.first
}

internal extension Array
{
    private var indexesInterval: HalfOpenInterval<Int> { return HalfOpenInterval<Int>(0, self.count) }
    
    /**
    Checks if self contains a list of items.
    
    :param: items Items to search for
    :returns: true if self contains all the items
    */
    func contains <T: Equatable> (items: T...) -> Bool
    {
        return items.all { self.indexOf($0) >= 0 }
    }
    
    /**
    Difference of self and the input arrays.
    
    :param: values Arrays to subtract
    :returns: Difference of self and the input arrays
    */
    func difference <T: Equatable> (values: [T]...) -> [T]
    {
        var result = [T]()
        
        elements: for e in self
        {
            if let element = e as? T
            {
                for value in values
                {
                    //  if a value is in both self and one of the values arrays
                    //  jump to the next iteration of the outer loop
                    if value.contains(element)
                    {
                        continue elements
                    }
                }
                
                //  element it's only in self
                result.append(element)
            }
        }
        
        return result
        
    }
    
    /**
    Intersection of self and the input arrays.
    
    :param: values Arrays to intersect
    :returns: Array of unique values contained in all the dictionaries and self
    */
    func intersection <U: Equatable> (values: [U]...) -> Array
    {
        var result = self
        var intersection = Array()
        
        for (i, value) in enumerate(values)
        {
            //  the intersection is computed by intersecting a couple per loop:
            //  self n values[0], (self n values[0]) n values[1], ...
            if (i > 0)
            {
                result = intersection
                intersection = Array()
            }
            
            //  find common elements and save them in first set
            //  to intersect in the next loop
            value.each
                {
                    (item: U) -> Void in
                    if result.contains(item)
                    {
                        intersection.append(item as! Element)
                    }
            }
            
        }
        
        return intersection
        
    }
    
    /**
    Union of self and the input arrays.
    
    :param: values Arrays
    :returns: Union array of unique values
    */
    func union <U: Equatable> (values: [U]...) -> Array
    {
        var result = self
        
        for array in values
        {
            for value in array
            {
                if !result.contains(value)
                {
                    result.append(value as! Element)
                }
            }
        }
        
        return result
    }
    
    /**
    First occurrence of item, if found.
    
    :param: item The item to search for
    :returns: Matched item or nil
    */
    func find <U: Equatable> (item: U) -> Element?
    {
        if let index = indexOf(item)
        {
            return self[index]
        }
        
        return nil
    }
    
    /**
    First item that meets the condition.
    
    :param: condition A function which returns a boolean if an element satisfies a given condition or not.
    :returns: First matched item or nil
    */
    func find (condition: Element -> Bool) -> Element?
    {
        return takeFirst(condition)
    }
    
    /**
    Index of the first occurrence of item, if found.
    
    :param: item The item to search for
    :returns: Index of the matched item or nil
    */
    func indexOf <U: Equatable> (item: U) -> Int?
    {
        if item is Element
        {
            return Swift.find(unsafeBitCast(self, [U].self), item)
        }
        
        return nil
    }
    
    /**
    Index of the first item that meets the condition.
    
    :param: condition A function which returns a boolean if an element satisfies a given condition or not.
    :returns: Index of the first matched item or nil
    */
    func indexOf (condition: Element -> Bool) -> Int?
    {
        for (index, element) in enumerate(self)
        {
            if condition(element)
            {
                return index
            }
        }
        
        return nil
    }
    
    /**
    Gets the index of the last occurrence of item, if found.
    
    :param: item The item to search for
    :returns: Index of the matched item or nil
    */
    func lastIndexOf <U: Equatable> (item: U) -> Int?
    {
        if item is Element
        {
            for (index, value) in enumerate(lazy(self).reverse())
            {
                if value as! U == item
                {
                    return count - 1 - index
                }
            }
            
            return nil
        }
        
        return nil
    }
    
    /**
    Gets the object at the specified index, if it exists.
    
    :param: index
    :returns: Object at index in self
    */
    func get (index: Int) -> Element?
    {
        return index >= 0 && index < count ? self[index] : nil
        
    }
    
    /**
    Randomly rearranges the elements of self using the Fisher-Yates shuffle
    */
    mutating func shuffle ()
    {
        for var i = self.count - 1; i >= 1; i--
        {
            let j = Int.random(upper: i)
            swap(&self[i], &self[j])
        }
        
    }
    
    /**
    Shuffles the values of the array into a new one
    
    :returns: Shuffled copy of self
    */
    func shuffled () -> Array
    {
        var shuffled = self
        
        shuffled.shuffle()
        
        return shuffled
    }
    
    /**
    Max value in the current array (if Array.Element implements the Comparable protocol).
    
    :returns: Max value
    */
    func max <U: Comparable> () -> U
    {
        return maxElement(map { return $0 as! U })
    }
    
    /**
    Min value in the current array (if Array.Element implements the Comparable protocol).
    
    :returns: Min value
    */
    func min <U: Comparable> () -> U
    {
        return minElement(map { return $0 as! U })
    }
    
    /**
    The value for which call(value) is highest.
    
    :returns: Max value in terms of call(value)
    */
    func maxBy <U: Comparable> (call: (Element) -> (U)) -> Element?
    {
        if let firstValue = self.first
        {
            var maxElement: T = firstValue
            var maxValue: U = call(firstValue)
            for i in 1..<self.count
            {
                let element: Element = self[i]
                let value: U = call(element)
                if value > maxValue
                {
                    maxElement = element
                    maxValue = value
                }
            }
            return maxElement
        }
        else
        {
            return nil
        }
        
    }
    
    /**
    The value for which call(value) is lowest.
    
    :returns: Min value in terms of call(value)
    */
    func minBy <U: Comparable> (call: (Element) -> (U)) -> Element?
    {
        if let firstValue = self.first
        {
            var minElement: T = firstValue
            var minValue: U = call(firstValue)
            for i in 1..<self.count
            {
                let element: Element = self[i]
                let value: U = call(element)
                if value < minValue
                {
                    minElement = element
                    minValue = value
                }
            }
            
            return minElement
        }
        else
        {
            return nil
        }
        
    }
    
    /**
    Iterates on each element of the array.
    
    :param: call Function to call for each element
    */
    func each (call: (Element) -> ())
    {
        for item in self
        {
            call(item)
        }
        
    }
    
    /**
    Iterates on each element of the array with its index.
    
    :param: call Function to call for each element
    */
    func each (call: (Int, Element) -> ())
    {
        for (index, item) in enumerate(self)
        {
            call(index, item)
        }
    }
    
    /**
    Checks if test returns true for any element of self.
    
    :param: test Function to call for each element
    :returns: true if test returns true for any element of self
    */
    func any (test: (Element) -> Bool) -> Bool
    {
        for item in self
        {
            if test(item)
            {
                return true
            }
        }
        
        return false
    }
    
    /**
    Checks if test returns true for all the elements in self
    
    :param: test Function to call for each element
    :returns: True if test returns true for all the elements in self
    */
    func all (test: (Element) -> Bool) -> Bool
    {
        for item in self
        {
            if !test(item)
            {
                return false
            }
        }
        
        return true
    }
    
    /**
    Opposite of filter.
    
    :param: exclude Function invoked to test elements for the exclusion from the array
    :returns: Filtered array
    */
    func reject (exclude: (Element -> Bool)) -> Array
    {
        return filter { return !exclude($0) }
    }
    
    /**
    Returns an array containing the first n elements of self.
    
    :param: n Number of elements to take
    :returns: First n elements
    */
    func take (n: Int) -> Array
    {
        return Array(self[0..<Swift.max(0, n)])
    }
    
    /**
    Returns the elements of the array up until an element does not meet the condition.
    
    :param: condition A function which returns a boolean if an element satisfies a given condition or not.
    :returns: Elements of the array up until an element does not meet the condition
    */
    func takeWhile (condition: (Element) -> Bool) -> Array
    {
        var lastTrue = -1
        
        for (index, value) in enumerate(self)
        {
            if condition(value)
            {
                lastTrue = index
            }
            else
            {
                break
            }
        }
        
        return take(lastTrue + 1)
        
    }
    
    /**
    Returns the first element in the array to meet the condition.
    
    :param: condition A function which returns a boolean if an element satisfies a given condition or not.
    :returns: The first element in the array to meet the condition
    */
    func takeFirst (condition: (Element) -> Bool) -> Element?
    {
        for value in self
        {
            if condition(value)
            {
                return value
            }
        }
        
        return nil
    }
    
    /**
    Constructs an array removing the duplicate values in self if Array.Element implements the Equatable protocol.
    
    :returns: Array of unique values
    */
    func unique <T: Equatable> () -> [T]
    {
        var result = [T]()
        
        for item in self
        {
            if !result.contains(item as! T)
            {
                result.append(item as! T)
            }
        }
        
        return result
    }
    
    /**
    Returns an Array of elements for which call(element) is unique
    
    :param: call The closure to use to determine uniqueness
    :returns: The set of elements for which call(element) is unique
    */
    func uniqueBy <T: Equatable> (call: (Element) -> (T)) -> [Element]
    {
        var result: [Element] = []
        var uniqueItems: [T] = []
        
        for item in self
        {
            var callResult: T = call(item)
            if !uniqueItems.contains(callResult)
            {
                uniqueItems.append(callResult)
                result.append(item)
            }
        }
        
        return result
    }
    
    /**
    Returns the number of elements which meet the condition
    
    :param: test Function to call for each element
    :returns: the number of elements meeting the condition
    */
    func countWhere (test: (Element) -> Bool) -> Int
    {
        var result = 0
        
        for item in self
        {
            if test(item)
            {
                result++
            }
        }
        
        return result
    }
    
    /**
    Joins the array elements with a separator.
    
    :param: separator
    :return: Joined object if self is not empty and its elements are instances of C, nil otherwise
    */
    func implode <C: ExtensibleCollectionType> (separator: C) -> C?
    {
        if Element.self is C.Type
        {
            return Swift.join(separator, unsafeBitCast(self, [C].self))
        }
        
        return nil
    }
    
    
    /**
    Creates an array with values generated by running each value of self
    through the mapFunction and discarding nil return values.
    
    :param: mapFunction
    :returns: Mapped array
    */
    func mapFilter <V> (mapFunction map: (Element) -> (V)?) -> [V]
    {
        var mapped = [V]()
        
        each
            {
                (value: Element) -> Void in
                if let mappedValue = map(value)
                {
                    mapped.append(mappedValue)
                }
        }
        
        return mapped
        
    }
    
    /**
    Creates an array with the elements at the specified indexes.
    
    :param: indexes Indexes of the elements to get
    :returns: Array with the elements at indexes
    */
    func at (indexes: Int...) -> Array
    {
        return indexes.map { self.get($0)! }
    }
    
    
    /**
    Calls the passed block for each element in the array, either n times or infinitely, if n isn't specified
    
    :param: n the number of times to cycle through
    :param: block the block to run for each element in each cycle
    */
    func cycle (n: Int? = nil, block: (T) -> ())
    {
        var cyclesRun = 0
        while true
        {
            if let n = n
            {
                if cyclesRun >= n
                {
                    break
                }
            }
            for item in self
            {
                block(item)
            }
            cyclesRun++
        }
    }
    
    /**
    Runs a binary search to find the smallest element for which the block evaluates to true
    The block should return true for all items in the array above a certain point and false for all items below a certain point
    If that point is beyond the furthest item in the array, it returns nil
    
    :param: block the block to run each time
    :returns: the min element, or nil if there are no items for which the block returns true
    */
    func bSearch (block: (T) -> (Bool)) -> T?
    {
        if count == 0
        {
            return nil
        }
        
        var low = 0
        var high = count - 1
        while low <= high
        {
            var mid = low + (high - low) / 2
            if block(self[mid])
            {
                if mid == 0 || !block(self[mid - 1])
                {
                    return self[mid]
                }
                else
                {
                    high = mid
                }
            }
            else
            {
                low = mid + 1
            }
        }
        
        return nil
    }
    
    /**
    Runs a binary search to find some element for which the block returns 0.
    The block should return a negative number if the current value is before the target in the array, 0 if it's the target, and a positive number if it's after the target
    The Spaceship operator is a perfect fit for this operation, e.g. if you want to find the object with a specific date and name property, you could keep the array sorted by date first, then name, and use this call:
    let match = bSearch
    {
    [targetDate, targetName] <=> [$0.date, $0.name] }
    
    See http://ruby-doc.org/core-2.2.0/Array.html#method-i-bsearch regarding find-any mode for more
    
    :param: block the block to run each time
    :returns: an item (there could be multiple matches) for which the block returns true
    */
    func bSearch (block: (T) -> (Int)) -> T?
    {
        let match = bSearch
            {
                item in
                block(item) >= 0
        }
        if let match = match
        {
            return block(match) == 0 ? match : nil
        }
        else
        {
            return nil
        }
    }
    
    /**
    Sorts the array by the value returned from the block, in ascending order
    
    :param: block the block to use to sort by
    :returns: an array sorted by that block, in ascending order
    */
    func sortUsing <U:Comparable> (block: ((T) -> U)) -> [T]
    {
        return self.sorted({ block($0.0) < block($0.1) })
    }
    
    /**
    Removes the last element from self and returns it.
    
    :returns: The removed element
    */
    mutating func pop () -> Element?
    {
        if self.isEmpty
        {
            return nil
        }
        
        return removeLast()
    }
    
    /**
    Same as append.
    
    :param: newElement Element to append
    */
    mutating func push (newElement: Element)
    {
        return append(newElement)
    }
    
    /**
    Returns the first element of self and removes it from the array.
    
    :returns: The removed element
    */
    mutating func shift () -> Element?
    {
        if self.isEmpty
        {
            return nil
        }
        
        return removeAtIndex(0)
        
    }
    
    /**
    Prepends an object to the array.
    
    :param: newElement Object to prepend
    */
    mutating func unshift (newElement: Element)
    {
        insert(newElement, atIndex: 0)
    }
    
    /**
    Deletes all the items in self that are equal to element.
    
    :param: element Element to remove
    */
    mutating func remove <U: Equatable> (element: U)
    {
        let anotherSelf = self
        
        removeAll(keepCapacity: true)
        
        anotherSelf.each
            {
                (index: Int, current: Element) in
                if (current as! U) != element
                {
                    self.append(current)
                }
        }
    }
    
    /**
    Returns the subarray in the given range.
    
    :param: range Range of the subarray elements
    :returns: Subarray or nil if the index is out of bounds
    */
    subscript (#rangeAsArray: Range<Int>) -> Array
        {
            //  Fix out of bounds indexes
            let start = Swift.max(0, rangeAsArray.startIndex)
            let end = Swift.min(rangeAsArray.endIndex, count)
            
            if start > end
            {
                return []
            }
            
            return Array(self[Range(start: start, end: end)] as ArraySlice<T>)
    }
    
    /**
    Returns a subarray whose items are in the given interval in self.
    
    :param: interval Interval of indexes of the subarray elements
    :returns: Subarray or nil if the index is out of bounds
    */
    subscript (interval: HalfOpenInterval<Int>) -> Array
        {
            return self[rangeAsArray: Range(start: interval.start, end: interval.end)]
    }
    
    /**
    Returns a subarray whose items are in the given interval in self.
    
    :param: interval Interval of indexes of the subarray elements
    :returns: Subarray or nil if the index is out of bounds
    */
    subscript (interval: ClosedInterval<Int>) -> Array
        {
            return self[rangeAsArray: Range(start: interval.start, end: interval.end + 1)]
    }
    
    /**
    Creates an array with the elements at indexes in the given list of integers.
    
    :param: first First index
    :param: second Second index
    :param: rest Rest of indexes
    :returns: Array with the items at the specified indexes
    */
    subscript (first: Int, second: Int, rest: Int...) -> Array
        {
            let indexes = [first, second] + rest
            return indexes.map
                {
                    self[$0] }
    }
    
}

/**
Remove an element from the array
*/
public func - <T: Equatable> (first: [T], second: T) -> [T]
{
    return first - [second]
}

/**
Difference operator
*/
public func - <T: Equatable> (first: [T], second: [T]) -> [T]
{
    return first.difference(second)
}

/**
Intersection operator
*/
public func & <T: Equatable> (first: [T], second: [T]) -> [T]
{
    return first.intersection(second)
}

/**
Union operator
*/
public func | <T: Equatable> (first: [T], second: [T]) -> [T]
{
    return first.union(second)
}
