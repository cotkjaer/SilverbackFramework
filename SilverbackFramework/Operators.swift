//
//  Operators.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 18/06/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import Foundation

infix operator =?=
{}
/// compares two optional Equatables and returns true if they are equal or one or both are nil
public func =?= <T:Equatable> (lhs: T?, rhs: T?) -> Bool
{
    if lhs == nil
{ return true }
    if rhs == nil
{ return true }
    return lhs == rhs
}

