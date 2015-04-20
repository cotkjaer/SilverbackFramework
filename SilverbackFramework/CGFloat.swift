//
//  CGFloat.swift
//  Pods
//
//  Created by Christian Otkjær on 20/04/15.
//
//

import CoreGraphics

// MARK: - CGFloat

extension CGFloat
{
    public func isEqualWithin(precision: CGFloat, to: CGFloat) -> Bool
    {
        return abs(self - to) < abs(precision)
    }
}

public func equalsWithin(precision: CGFloat, f1: CGFloat, to f2: CGFloat) -> Bool
{
    return abs(f1 - f2) < abs(precision)
}

public func * (rhs: CGFloat, lhs: Int) -> CGFloat
{
    return rhs * CGFloat(lhs)
}

public func * (rhs: Int, lhs: CGFloat) -> CGFloat
{
    return CGFloat(rhs) * lhs
}

public func += (inout rhs: CGFloat, lhs: Int)
{
    rhs += CGFloat(lhs)
}

public func -= (inout rhs: CGFloat, lhs: Int)
{
    rhs += CGFloat(lhs)
}

public func *= (inout rhs: CGFloat, lhs: Int)
{
    rhs *= CGFloat(lhs)
}

public func /= (inout rhs: CGFloat, lhs: Int)
{
    rhs /= CGFloat(lhs)
}

