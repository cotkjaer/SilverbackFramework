//
//  NSIndexPath.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 02/06/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import Foundation

extension NSIndexPath : Comparable {}

public func == (lhs: NSIndexPath, rhs: NSIndexPath) -> Bool
{
    if lhs.length == rhs.length
    {
        for index in 0 ..< lhs.length
        {
            if lhs.indexAtPosition(index) != rhs.indexAtPosition(index)
            {
                return false
            }
        }
        
        return true
    }
    
    return false
}

public func < (lhs: NSIndexPath, rhs: NSIndexPath) -> Bool
{
    if lhs.length <= rhs.length
    {
        for index in 0 ..< lhs.length
        {
            if lhs.indexAtPosition(index) < rhs.indexAtPosition(index)
            {
                return true
            }
        }
        
        return false
    }
    
    return false
}
