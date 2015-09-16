//
//  Bool.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 20/04/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import Foundation

public extension Bool
{
    func toggled() -> Bool
    {
        return !self
    }
    
    mutating func toggle() -> Bool
    {
        self = !self
        return self
    }
    
    static func random() -> Bool
    {
        return Double.random(lower: 0, upper: 1) < 0.500
    }
}

extension Bool: Comparable {}

public func < (lhs: Bool, rhs: Bool) -> Bool
{
    if rhs { return !lhs }
    
    return false
}
