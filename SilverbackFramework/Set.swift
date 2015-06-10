//
//  Set.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 20/04/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import Foundation

extension Set
{
    func map<U:Equatable>(transform: (T) -> U?) -> Set<U>
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
    
    func filter(check: (T) -> Bool) -> Set<T>
    {
        var set = Set<T>()
        
        for e in self
        {
            if check(e)
            {
                set.insert(e)
            }
        }
        
        return set
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