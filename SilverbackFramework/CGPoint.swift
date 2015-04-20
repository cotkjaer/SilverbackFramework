//
//  CGPoint.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 20/04/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import CoreGraphics

// MARK: - CGPoint

extension CGPoint
{
    public init(_ x: CGFloat, _ y: CGFloat)
    {
        self.x = x
        self.y = y
    }
    
    // MARK: with
    
    public func with(# x: CGFloat) -> CGPoint
    {
        return CGPoint(x, y)
    }
    
    public func with(# y: CGFloat) -> CGPoint
    {
        return CGPoint(x, y)
    }
    
    // MARK: distance
    
    public func distanceTo(point: CGPoint) -> CGFloat
    {
        return sqrt(pow(x - point.x, 2) + pow(y - point.y, 2))
    }
    
    // MARK: rotation
    
    /// angle is in radians
    public mutating func rotate(theta:CGFloat, around center:CGPoint)
    {
        let sinTheta = sin(theta)
        let cosTheta = cos(theta)
        
        let transposedX = x - center.x
        let transposedY = y - center.y
        
        x = center.x + (transposedX * cosTheta - transposedY * sinTheta)
        y = center.y + (transposedX * sinTheta + transposedY * cosTheta)
    }
}

func rotate(point p1:CGPoint, radians: CGFloat, around p2:CGPoint) -> CGPoint
{
    let sinTheta = sin(radians)
    let cosTheta = cos(radians)
    
    let transposedX = p1.x - p2.x
    let transposedY = p1.y - p2.y
    
    return CGPoint(p2.x + (transposedX * cosTheta - transposedY * sinTheta),
                   p2.y + (transposedX * sinTheta + transposedY * cosTheta))

}


func distanceFrom(p1:CGPoint, to p2:CGPoint) -> CGFloat
{
    return sqrt(pow((p2.x - p1.x), 2) + pow((p2.y - p1.y), 2))
}

func midPoint(between p1:CGPoint, and p2:CGPoint) -> CGPoint
{
    return CGPoint((p1.x + p2.x) / 2.0, (p1.y + p2.y) / 2.0)
}


// MARK: Equatable

extension CGPoint: Equatable
{
    func isEqualTo(point: CGPoint, withPrecision precision:CGFloat) -> Bool
    {
        return  distanceTo(point) < abs(precision)
    }
    
    public func isEqualTo(point:CGPoint) -> Bool
    {
        return self == point
    }
}

public func == (p1: CGPoint, p2: CGPoint) -> Bool
{
    return p1.x == p2.x && p1.y == p2.y
}

func isEqual(p1: CGPoint, p2: CGPoint, withPrecision precision:CGFloat) -> Bool
{
    return distanceFrom(p1, to:p2) < abs(precision)
}

// MARK: operators

public func + (p1: CGPoint, p2: CGPoint) -> CGPoint
{
    return CGPoint(p1.x + p2.x, p1.y + p2.y)
}

public func += (inout p1: CGPoint, p2: CGPoint)
{
    p1.x += p2.x
    p1.y += p2.y
}

public func - (p1: CGPoint, p2: CGPoint) -> CGPoint
{
    return CGPoint(p1.x - p2.x, p1.y - p2.y)
}

public func -= (inout p1: CGPoint, p2: CGPoint)
{
    p1.x -= p2.x
    p1.y -= p2.y
}

public func + (point: CGPoint, size: CGSize) -> CGPoint
{
    return CGPoint(point.x + size.width, point.y + size.height)
}

public func += (inout point: CGPoint, size: CGSize)
{
    point.x += size.width
    point.y += size.height
}

public func - (point: CGPoint, size: CGSize) -> CGPoint
{
    return CGPoint(point.x - size.width, point.y - size.height)
}

public func -= (inout point: CGPoint, size: CGSize)
{
    point.x -= size.width
    point.y -= size.height
}

public func * (factor: CGFloat, point: CGPoint) -> CGPoint
{
    return CGPoint(point.x * factor, point.y * factor)
}

public func * (point: CGPoint, factor: CGFloat) -> CGPoint
{
    return CGPoint(point.x * factor, point.y * factor)
}

public func *= (inout point: CGPoint, factor: CGFloat)
{
    point.x *= factor
    point.y *= factor
}

public func / (point: CGPoint, factor: CGFloat) -> CGPoint
{
    return CGPoint(point.x / factor, point.y / factor)
}

public func /= (inout point: CGPoint, factor: CGFloat)
{
    point.x /= factor
    point.y /= factor
}

public func * (point: CGPoint, transform: CGAffineTransform) -> CGPoint
{
    return CGPointApplyAffineTransform(point, transform)
}

public func *= (inout point: CGPoint, transform: CGAffineTransform)
{
    point = point * transform//CGPointApplyAffineTransform(point, transform)
}



