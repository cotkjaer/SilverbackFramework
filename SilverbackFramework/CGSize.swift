//
//  CGSize.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 20/04/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import CoreGraphics

// MARK: - CGSize

extension CGSize
{
    public init(_ width: CGFloat, _ height: CGFloat)
{
        self.width = width
        self.height = height
    }
    
    // MARK: with
    
    public func with(# width: CGFloat) -> CGSize
{
        return CGSize(width, height)
    }
    
    public func with(# height: CGFloat) -> CGSize
{
        return CGSize(width, height)
    }
}

// MARK: Equatable

extension CGSize: Equatable
{
    public func isEqualTo(size:CGSize) -> Bool
{
        return self == size
    }
}

public func == (s1: CGSize, s2: CGSize) -> Bool
{
    return s1.width == s2.width && s1.height == s2.height
}

// MARK: operators

public func + (s1: CGSize, s2: CGSize) -> CGSize
{
    return CGSize(s1.width + s2.width, s1.height + s2.height)
}

public func += (inout s1: CGSize, s2: CGSize)
{
    s1.width += s2.width
    s1.height += s2.height
}

public func - (s1: CGSize, s2: CGSize) -> CGSize
{
    return CGSize(s1.width - s2.width, s1.height - s2.height)
}

public func -= (inout s1: CGSize, s2: CGSize)
{
    s1.width -= s2.width
    s1.height -= s2.height
}

public func * (size: CGSize, factor: CGFloat) -> CGSize
{
    return CGSize(size.width * factor, size.height * factor)
}

public func * (factor: CGFloat, size: CGSize) -> CGSize
{
    return size * factor
}

public func *= (inout size: CGSize, factor: CGFloat)
{
    size.width *= factor
    size.height *= factor
}

public func / (size: CGSize, factor: CGFloat) -> CGSize
{
    return CGSize(size.width / factor, size.height / factor)
}

public func /= (inout size: CGSize, factor: CGFloat)
{
    size.width /= factor
    size.height /= factor
}

public func * (size: CGSize, transform: CGAffineTransform) -> CGSize
{
    return CGSizeApplyAffineTransform(size, transform)
}

public func *= (inout size: CGSize, transform: CGAffineTransform)
{
    size = size * transform//CGSizeApplyAffineTransform(size, transform)
}

