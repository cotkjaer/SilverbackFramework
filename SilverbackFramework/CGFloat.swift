//
//  CGFloat.swift
//  Pods
//
//  Created by Christian Otkjær on 20/04/15.
//
//

import CoreGraphics

// MARK: - CGFloat

func isEqual(f1:CGFloat, to f2:CGFloat, precision:CGFloat) -> Bool
{
    return abs(f1-f2) < abs(precision)
}

public func * (float: CGFloat, int: Int) -> CGFloat
{
    return CGFloat(int) * float
}

public func * (int: Int, float: CGFloat) -> CGFloat
{
    return CGFloat(int) * float
}

public func *= (inout float: CGFloat, int: Int)
{
    float *= CGFloat(int)
}