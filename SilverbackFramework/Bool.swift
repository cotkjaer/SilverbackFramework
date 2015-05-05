//
//  Bool.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 20/04/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import Foundation

extension Bool
{
    public mutating func toggle() -> Bool
    {
        self = !self
        return self
    }
    
    public static func random() -> Bool
    {
        return Double.random(lower: 0, upper: 1) < 0.500
    }
}
