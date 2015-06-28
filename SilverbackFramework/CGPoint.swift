//
//  CGPoint.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 20/04/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import CoreGraphics
import UIKit

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
    
    
    // MARK: mid way
    
    public func midWayTo(p2:CGPoint) -> CGPoint
    {
        return CGPoint((self.x + p2.x) / 2.0, (self.y + p2.y) / 2.0)
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
    
    public func angleToPoint(point: CGPoint) -> CGFloat
    {
        return atan2(point.y - y, point.x - x)
    }
}

public func rotate(point p1:CGPoint, radians: CGFloat, around p2:CGPoint) -> CGPoint
{
    let sinTheta = sin(radians)
    let cosTheta = cos(radians)
    
    let transposedX = p1.x - p2.x
    let transposedY = p1.y - p2.y
    
    return CGPoint(p2.x + (transposedX * cosTheta - transposedY * sinTheta),
        p2.y + (transposedX * sinTheta + transposedY * cosTheta))
    
}

public func distanceFrom(p1:CGPoint, to p2:CGPoint) -> CGFloat
{
    return sqrt(pow((p2.x - p1.x), 2) + pow((p2.y - p1.y), 2))
}

public func midPoint(between p1:CGPoint, and p2:CGPoint) -> CGPoint
{
    return CGPoint((p1.x + p2.x) / 2.0, (p1.y + p2.y) / 2.0)
}


// MARK: - Equatable

extension CGPoint: Equatable
{
    public func isEqualTo(point: CGPoint, withPrecision precision:CGFloat) -> Bool
    {
        return  distanceTo(point) < abs(precision)
    }
    
    public func isEqualTo(point:CGPoint) -> Bool
    {
        return self == point
    }
}

public func ==(lhs: CGPoint, rhs: CGPoint) -> Bool
{
    return lhs.x == rhs.x && lhs.y == rhs.y
}

public func isEqual(p1: CGPoint, p2: CGPoint, withPrecision precision:CGFloat) -> Bool
{
    return distanceFrom(p1, to:p2) < abs(precision)
}


// MARK: - Comparable

extension CGPoint: Comparable
{
}

/// CAVEAT: first y then x comparison
public func > (p1: CGPoint, p2: CGPoint) -> Bool
{
    return (p1.y < p2.y) || ((p1.y == p2.y) && (p1.x < p2.x))
}

public func < (p1: CGPoint, p2: CGPoint) -> Bool
{
    return (p1.y > p2.y) || ((p1.y == p2.y) && (p1.x > p2.x))
}

// MARK: - Operators

public func + (p1: CGPoint, p2: CGPoint) -> CGPoint
{
    return CGPoint(p1.x + p2.x, p1.y + p2.y)
}

public func += (inout p1: CGPoint, p2: CGPoint)
{
    p1.x += p2.x
    p1.y += p2.y
}

public prefix func - (p: CGPoint) -> CGPoint
{
    return CGPoint(-p.x, -p.y)
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

//MARK: - Random

public extension CGPoint
{
    /**
    Create a random CGFloat
    :param: center center, defaults to (0, 0)
    :param: lowerRadius bounds, defaults to 0
    :param: upperRadius bounds
    :return: random number CGFloat
    */
    static func random(center: CGPoint = CGPointZero, lowerRadius: CGFloat = 0, upperRadius: CGFloat) -> CGPoint
    {
        let upper = max(abs(upperRadius), abs(lowerRadius))
        let lower = min(abs(upperRadius), abs(lowerRadius))
        
        let radius = CGFloat.random(lower: lower, upper: upper)
        let alpha = CGFloat.random(lower: 0, upper: 2 * π)
        
        return CGPoint(x: center.x + cos(alpha) * radius, y: center.y + sin(alpha) * radius)
    }
    
    /**
    Create a random CGFloat
    :param: path, bounding path for random point
    :param: lowerRadius bounds, defaults to 0
    :param: upperRadius bounds
    :return: random number CGFloat
    */
    static func random(insidePath: UIBezierPath) -> CGPoint?
    {
        let bounds = insidePath.bounds
        
        for tries in 0...100
        {
            let point =
            CGPoint(x: CGFloat.random(lower: bounds.minX, upper: bounds.maxX),
                y: CGFloat.random(lower: bounds.minY, upper: bounds.maxY))
            
            if insidePath.containsPoint(point)
            {
                return point
            }
        }
        
        return nil
    }
    
}



