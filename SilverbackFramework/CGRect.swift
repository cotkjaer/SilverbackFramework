//
//  CGRect.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 20/04/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import CoreGraphics

// MARK: - CGRect

extension CGRect
{
    public init(center c: CGPoint, size s: CGSize)
    {
        origin = c - (s / 2)
        size = s
    }
    
//    public init(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat)
//    {
//        origin = CGPoint(x, y)
//        size = CGSize(width, height)
//    }
    
    public var center: CGPoint
        {
        get { return CGPoint(centerX, centerY) }
        set { centerX = newValue.x; centerY = newValue.y }
    }
    
    // MARK: shortcuts
    
    public var x: CGFloat
        {
        get { return origin.x }
        set { origin.x = newValue }
    }
    
    public var y: CGFloat
        {
        get { return origin.y }
        set { origin.y = newValue }
    }
    
    // CoreGraphics now contains read-only versions of height and width
    //    public var width: CGFloat
    //        {
    //        get { return size.width }
    //        set { size.width = newValue }
    //    }
    //
    //    public var height: CGFloat
    //        {
    //        get { return size.height }
    //        set { size.height = newValue }
    //    }
    
    // MARK: private center
    
    private var centerX: CGFloat
        {
        get { return x + width * 0.5 }
        set { x = newValue - width * 0.5 }
    }
    
    private var centerY: CGFloat
        {
        get { return y + height * 0.5 }
        set { y = newValue - height * 0.5 }
    }
    
    // MARK: edges
    
    public var top: CGFloat
        {
        get { return y }
        set { y = newValue }
    }
    
    public var left: CGFloat
        {
        get { return origin.x }
        set { origin.x = newValue }
    }
    
    public var right: CGFloat
        {
        get { return x + width }
        set { x = newValue - width }
    }
    
    public var bottom: CGFloat
        {
        get { return y + height }
        set { y = newValue - height }
    }
    
    
    // MARK: CGRectGet...
    
    public var minX : CGFloat { get { return CGRectGetMinX(self) } }
    public var midX : CGFloat { get { return CGRectGetMidX(self) } }
    public var maxX : CGFloat { get { return CGRectGetMaxX(self) } }
    
    public var minY : CGFloat { get { return CGRectGetMinY(self) } }
    public var midY : CGFloat { get { return CGRectGetMidY(self) } }
    public var maxY : CGFloat { get { return CGRectGetMaxY(self) } }
    
    
    // MARK: Contains
    
    public func contains(point: CGPoint) -> Bool
    {
        return CGRectContainsPoint(self, point)
    }
    
    public func contains(rect: CGRect) -> Bool
    {
        return CGRectContainsRect(self, rect)
    }
    
    // MARK: Intersects
    
    public func intersects(rect: CGRect) -> Bool
    {
        return CGRectIntersectsRect(self, rect)
    }
    
    // MARK: with
    
    public func with(# origin: CGPoint) -> CGRect
    {
        return CGRect(origin: origin, size: size)
    }
    
    public func with(# center: CGPoint) -> CGRect
    {
        return CGRect(center: center, size: size)
    }
    
    public func with(# x: CGFloat, y: CGFloat) -> CGRect
    {
        return with(origin: CGPoint(x, y))
    }
    
    public func with(# x: CGFloat) -> CGRect
    {
        return with(x: x, y: y)
    }
    
    public func with(# y: CGFloat) -> CGRect
    {
        return with(x: x, y: y)
    }
    
    public func with(# size: CGSize) -> CGRect
    {
        return CGRect(origin: origin, size: size)
    }
    
    public func with(# width: CGFloat, height: CGFloat) -> CGRect
    {
        return with(size: CGSize(width, height))
    }
    
    public func with(# width: CGFloat) -> CGRect
    {
        return with(width: width, height: height)
    }
    
    public func with(# height: CGFloat) -> CGRect
    {
        return with(width: width, height: height)
    }
    
    public func with(# x: CGFloat, width: CGFloat) -> CGRect
    {
        return CGRect(origin: CGPoint(x, y), size: CGSize(width, height))
    }
    
    public func with(# y: CGFloat, height: CGFloat) -> CGRect
    {
        return CGRect(origin: CGPoint(x, y), size: CGSize(width, height))
    }
    
    // MARK: inset
    
    public mutating func inset(by: CGFloat)
    {
        inset(dx: by, dy: by)
    }
    
    public mutating func inset(# dx: CGFloat)
    {
        inset(dx: dx, dy: 0)
    }
    
    public mutating func inset(# dy: CGFloat)
    {
        inset(dx: 0, dy: dy)
    }
    
    public mutating func inset(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0)
    {
        x = x + left
        y = y + top
        size.width = width - right - left
        size.height = height - top - bottom
    }
    
    public mutating func inset(# topLeft: CGSize)
    {
        inset(top: topLeft.height, left: topLeft.width)
    }
    
    public mutating func inset(# topRight: CGSize)
    {
        inset(top: topRight.height, right: topRight.width)
    }
    
    public mutating func inset(# bottomLeft: CGSize)
    {
        inset(bottom: bottomLeft.height, left: bottomLeft.width)
    }
    
    public mutating func inset(# bottomRight: CGSize)
    {
        inset(bottom: bottomRight.height, right: bottomRight.width)
    }
}

// MARK: - Edge points
extension CGRect
{
    public var topLeft: CGPoint
        {
        get { return CGPoint(left, top) }
        set { left = newValue.x; top = newValue.y }
    }
    
    public var topCenter: CGPoint
        {
        get { return CGPoint(centerX, top) }
        set { centerX = newValue.x; top = newValue.y }
    }
    
    public var topRight: CGPoint
        {
        get { return CGPoint(right, top) }
        set { right = newValue.x; top = newValue.y }
    }
    
    public var centerLeft: CGPoint
        {
        get { return CGPoint(left, centerY) }
        set { left = newValue.x; centerY = newValue.y }
    }
    
    public var centerRight: CGPoint
        {
        get { return CGPoint(right, centerY) }
        set { right = newValue.x; centerY = newValue.y }
    }
    
    public var bottomLeft: CGPoint
        {
        get { return CGPoint(left, bottom) }
        set { left = newValue.x; bottom = newValue.y }
    }
    
    public var bottomCenter: CGPoint
        {
        get { return CGPoint(centerX, bottom) }
        set { centerX = newValue.x; bottom = newValue.y }
    }
    
    public var bottomRight: CGPoint
        {
        get { return CGPoint(right, bottom) }
        set { right = newValue.x; bottom = newValue.y }
    }
}

// MARK: - Relative position

extension CGRect
{
    public func isAbove(rect:CGRect) -> Bool
    {
        return bottom > rect.top
    }

    public func isBelow(rect:CGRect) -> Bool
    {
        return top > rect.bottom
    }
    
    public func isLeftOf(rect:CGRect) -> Bool
    {
        return right < rect.left
    }
    
    public func isRightOf(rect:CGRect) -> Bool
    {
        return left < rect.right
    }
}

// MARK: Equatable

extension CGRect: Equatable
{
    public func isEqualTo(rect:CGRect) -> Bool
    {
        return CGRectEqualToRect(self, rect)
    }
}

public func == (r1: CGRect, r2: CGRect) -> Bool
{
    return CGRectEqualToRect(r1, r2)
}

// MARK: Operators

public func + (rect: CGRect, point: CGPoint) -> CGRect
{
    return CGRect(origin: rect.origin + point, size: rect.size)
}

public func += (inout rect: CGRect, point: CGPoint)
{
    rect.origin += point
}

public func - (rect: CGRect, point: CGPoint) -> CGRect
{
    return CGRect(origin: rect.origin - point, size: rect.size)
}

public func -= (inout rect: CGRect, point: CGPoint)
{
    rect.origin -= point
}

public func + (rect: CGRect, size: CGSize) -> CGRect
{
    return CGRect(origin: rect.origin, size: rect.size + size)
}

public func += (inout rect: CGRect, size: CGSize)
{
    rect.size += size
}

public func - (rect: CGRect, size: CGSize) -> CGRect
{
    return CGRect(origin: rect.origin, size: rect.size - size)
}

public func -= (inout rect: CGRect, size: CGSize)
{
    rect.size -= size
}

public func * (rect: CGRect, factor: CGFloat) -> CGRect
{
    return CGRect(center: rect.center, size: rect.size * factor)
}

public func * (factor: CGFloat, rect: CGRect) -> CGRect
{
    return rect * factor
}

public func *= (inout rect: CGRect, factor: CGFloat)
{
    rect = rect * factor
}

public func * (rect: CGRect, transform: CGAffineTransform) -> CGRect
{
    return CGRectApplyAffineTransform(rect, transform)
}

public func *= (inout rect: CGRect, transform: CGAffineTransform)
{
    rect = rect * transform//CGRectApplyAffineTransform(rect, transform)
}

