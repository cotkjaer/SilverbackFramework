//
//  Set.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 20/04/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import Foundation

public func + <T:Hashable>(lhs: Set<T>?, rhs: T) -> Set<T>
{
    if let l = lhs
    {
        return Set(element:rhs).union(l)
    }
    else
    {
        return Set(element: rhs)
    }
}

public func + <T:Hashable>(lhs: T, rhs: Set<T>?) -> Set<T>
{
    return rhs + lhs
}


public extension Set
{
    public func each(@noescape closure: ((element: Element, inout stop: Bool) -> ()))
    {
        var stop : Bool = false
        
        for e in self
        {
            closure(element: e, stop: &stop)
            
            if stop { break }
        }
    }
    
    public func any(@noescape check:((Element) -> Bool) = { _ in return true }) -> Element?
    {
        for e in self
        {
            if check(e) { return e }
        }
        
        return nil
    }
    
    public func all(@noescape check:((Element) -> Bool)) -> Set<Element>
    {
        return filter(check)
    }
    
    
    /**
    Finds the first element which meets the condition.
    
    - parameter condition: A closure which takes an Element and returns a Bool
    - returns: First element to match contidion or nil, if none matched
    */
    func find(condition: Element -> Bool) -> Element?
    {
        for element in self
        {
            if condition(element) { return element }
        }
        return nil
    }
}


public extension Set
{
    public init(element: Element?)
    {
        if let e = element { self.init([e]) } else { self.init() }
    }
    
    /// Insert an optional element into the set
    /// - returns: **true** if the element was inserted, **false** otherwise
    mutating func insert(optionalElement: Element?) -> Bool
    {
        if let element = optionalElement
        {
            if !contains(element)
            {
                insert(element)
                return true
            }
        }
        
        return false
    }
    
    
    func map<U:Equatable>(transform: (Element) -> U?) -> Set<U>
    {
        var set = Set<U>()
        
        for e in self
        {
            if let ee = transform(e)
            {
                set.insert(ee)
            }
        }
        
        return set
    }
    
    func contains(element: Element?) -> Bool
    {
        if let e = element
        {
            return contains(e)
        }
        
        return false
    }
    
    @warn_unused_result func intersects<S : SequenceType where S.Generator.Element == Element>(sequence: S?) -> Bool
    {
        return sequence?.contains({contains($0)}) ?? false
    }
    
    func filter(@noescape check: (Element) -> Bool) -> Set<Element>
    {
        var set = Set<Element>()
        
        for e in self
        {
            if check(e)
            {
                set.insert(e)
            }
        }
        
        return set
    }
    
    /**
    Iterates on each element of the set.
    
    - parameter closure: invoked for each element in the set, setting the stop parameter to true will stop the iteration
    */
    func iterate(closure: ((element: Element, inout stop: Bool) -> ()))
    {
        var stop : Bool = false
        
        for element in self
        {
            closure(element: element, stop: &stop)
            
            if stop { break }
        }
    }
    
    /**
    Iterates on each element of the set.
    
    - parameter closure: invoked for each element in the set, setting the stop parameter to true will stop the iteration
    */
    func iterate(@noescape closure: ((element: Element) -> ()))
    {
        for element in self
        {
            closure(element: element)
        }
    }
}

func filter<T>(set:Set<T>, check: (T) -> Bool) -> Set<T>
{
    var res = Set<T>()
    
    for e in set
    {
        if check(e)
        {
            res.insert(e)
        }
    }
    
    return res
}


func flatten<T>(set:Set<Set<T>>) -> Set<T>
{
    var res = Set<T>()
    
    for s in set
    {
        for e in s
        {
            res.insert(e)
        }
    }
    
    return res
}