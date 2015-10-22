//
//  BezierCurve.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 18/08/15.
//  Copyright © 2015 Christian Otkjær. All rights reserved.
//

import Foundation

public class BezierCurve
{
    private let points : [CGPoint]
    
    init(points:[CGPoint])
    {
        self.points = points
    }
    
    init(_ points:CGPoint...)
    {
        self.points = points
    }
    
    var order: Int { return points.count }
    
    func split(at t: CGFloat = 0.5) -> (BezierCurve, BezierCurve)
    {
        let pps = splitBezierCurve(points, t: t)
        
        return (BezierCurve(points: pps[0]), BezierCurve(points: pps[1]))
    }
    
    func point(at t: CGFloat) -> CGPoint
    {
        return bezierPoint(points, t: t)
    }
    
    func pointAndVelocity(at t: CGFloat) -> (CGPoint, CGVector)
    {
        if order == 1 { return (beginPoint, CGVectorZero) }
        
        
        let (_, remaining) = split(at: t)
        
        return (remaining.beginPoint, CGVector(remaining.points[1] - remaining.points[0]))
    }
    
    var endPoint : CGPoint { return points.last! }
    
    var beginPoint : CGPoint { return points.first! }
    
    public func lengthWithThreshold(threshold: CGFloat) -> CGFloat
    {
        let d = distance(beginPoint, endPoint)
        
        if d < threshold
        {
            return d
        }
        
        let parts = split()
        return parts.0.lengthWithThreshold(threshold) + parts.1.lengthWithThreshold(threshold)
    }
    
    public lazy var length : CGFloat = { return self.lengthWithThreshold(CGFloat(1) / UIScreen.mainScreen().scale) }()
}

extension BezierCurve : Equatable { }

public func == (lhs: BezierCurve, rhs: BezierCurve) -> Bool
{
    return lhs.points == rhs.points
}

extension BezierCurve : CustomDebugStringConvertible
{
    public var debugDescription: String
        {
            let orderString = NSNumberFormatter(numberStyle: .OrdinalStyle).stringFromNumber(order) ?? "\(order)"
            
            return "\(orderString) order Bézier curve with points \(points)"
    }
}


public enum BezierCurveEnum
{
    case Point(CGPoint)
    case Liniar(CGPoint, CGPoint)
    case Quadratic(CGPoint, CGPoint, CGPoint)
    case Cubic(CGPoint, CGPoint, CGPoint, CGPoint)
    case Generic([CGPoint])
    
    init(points:[CGPoint])
    {
        switch points.count
        {
        case 1: self = .Point(points[0])
        case 2: self = .Liniar(points[0], points[1])
        case 3: self = .Quadratic(points[0], points[1], points[2])
        case 4: self = .Cubic(points[0], points[1], points[2], points[3])
        default: self = .Generic(points)
        }
    }
    
    func split(at t: CGFloat = 0.5) -> (BezierCurveEnum, BezierCurveEnum)
    {
        precondition(0 <= t && t <= 1, "t should be between 0 and 1, not \(t)")

        switch self
        {
        case let .Point(p):
            return (.Point(p), .Point(p))
            
        case let .Liniar(a, b):
            let ab = lerp(a,b, t)           // point between a and b
            return (.Liniar(a, ab), .Liniar(ab, b))
            
        case let .Quadratic(a,b,c):
            let ab = lerp(a,b,t)           // point between a and b
            let bc = lerp(b,c,t)           // point between b and c
            
            let ab_bc = lerp(ab,bc,t)       // point between ab and bc
            
            return (.Quadratic(a, ab, ab_bc), .Quadratic(ab_bc, bc, c))
            
        case let .Cubic(a,b,c,d):
            let ab = lerp(a,b,t)           // point between a and b
            let bc = lerp(b,c,t)           // point between b and c
            let cd = lerp(c,d,t)           // point between c and d
            
            let ab_bc = lerp(ab,bc,t)       // point between ab and bc
            let bc_cd = lerp(bc,cd,t)       // point between bc and cd
            
            let abbc_bccd = lerp(ab_bc,bc_cd, t) // point between ab_bc and bc_cd
            
            return (.Cubic(a, ab, ab_bc, abbc_bccd), .Cubic(abbc_bccd, bc_cd, cd, d))
            
        case let .Generic(ps):
            preconditionFailure("TODO: implement spilt for curve of order \(ps.count)")
        }
    }
    
    /**
    Point on the Bézier curve using DeCasteljau subdivision
    - parameter t: percentage of distance traveled from begin point to end point, defaults to 0.5
    */
    func point(at t: CGFloat) -> CGPoint
    {
        precondition(0 <= t && t <= 1, "t should be between 0 and 1, not \(t)")
        
        switch self
        {
        case let .Point(p):
            return p
            
        case let .Liniar(a, b):
            return lerp(a,b,t)           // point between a and b
            
        case let .Quadratic(a,b,c):
            let ab = lerp(a,b,t)           // point between a and b
            let bc = lerp(b,c,t)           // point between b and c
            
            return lerp(ab,bc,t)       // point between ab and bc
            
        case let .Cubic(a,b,c,d):
            let ab = lerp(a,b,t)           // point between a and b
            let bc = lerp(b,c,t)           // point between b and c
            let cd = lerp(c,d,t)           // point between c and d
            
            let ab_bc = lerp(ab,bc,t)       // point between ab and bc
            let bc_cd = lerp(bc,cd,t)       // point between bc and cd
            
            return lerp(ab_bc,bc_cd,t) // point between ab_bc and bc_cd
            
        case let .Generic(ps):
            preconditionFailure("TODO: implement spilt for curve of order \(ps.count)")
        }
    }
    
    var endPoint : CGPoint
        {
            switch self
            {
            case let .Point(point): return point
                
            case let .Liniar(_, endPoint): return endPoint
                
            case let .Quadratic(_, _, endPoint): return endPoint
                
            case let .Cubic(_, _, _, endPoint): return endPoint
                
            case let .Generic(ps) : return ps.last ?? CGPointZero
            }
    }
    
    var beginPoint : CGPoint
        {
            switch self
            {
            case let .Point(p): return p
                
            case let .Liniar(p, _): return p
                
            case let .Quadratic(p, _, _): return p
                
            case let .Cubic(p, _, _, _): return p
                
            case let .Generic(ps) : return ps.first ?? CGPointZero
                
            }
    }
    
    public func lengthWithThreshold(threshold: CGFloat) -> CGFloat
    {
        let d = distance(beginPoint, endPoint)
        
        if d < threshold
        {
            return d
        }
        
        let parts = split()
        return parts.0.lengthWithThreshold(threshold) + parts.1.lengthWithThreshold(threshold)
    }
    
    public var length : CGFloat { return lengthWithThreshold(CGFloat(1) / UIScreen.mainScreen().scale) }
}

extension BezierCurveEnum : Equatable
{ }

public func ==(lhs: BezierCurveEnum, rhs: BezierCurveEnum) -> Bool
{
    switch(lhs, rhs)
    {
    case let (.Point(l), .Point(r)):
        return l == r
    case let (.Liniar(al,bl), .Liniar(ar,br)):
        return al == ar && bl == br
    case let (.Quadratic(l1, l2,l3), .Quadratic(r1, r2, r3)):
        return l1 == r1 && l2 == r2 && l3 == r3
    case let (.Cubic(l1, l2, l3, l4), .Cubic(r1, r2, r3, r4)):
        return l1 == r1 && l2 == r2 && l3 == r3 && l4 == r4
    case (_, _):
        return false
    }
}


/**
evaluate a point on a cubic Bézier curve using DeCasteljau Subdivision
- parameter a: begin point
- parameter b: control point 1
- parameter c: control point 2
- parameter d: end point
- parameter t: percentage of distance traveled from begin point to end point, defaults to 0.5
*/
public func DeCasteljauCubicBezierPoint(a: CGPoint, b : CGPoint, c : CGPoint, d : CGPoint, t: CGFloat = 0.5) -> CGPoint
{
    let ab = lerp(a,b,t)           // point between a and b
    let bc = lerp(b,c,t)           // point between b and c
    let cd = lerp(c,d,t)           // point between c and d
    let abbc = lerp(ab,bc,t)       // point between ab and bc
    let bccd = lerp(bc,cd,t)       // point between bc and cd
    return lerp(abbc,bccd,t)       // point on the bezier-curve
}

/**
evaluate a point on any order Bézier curve using [De Casteljau subdivision algoritm](https://en.wikipedia.org/wiki/De_Casteljau%27s_algorithm)
- parameter ps: points defining the curve, ps.first is begin point and ps.last is endPoint
- parameter t: percentage of distance traveled from begin point to end point
*/
public func bezierPoint(ps: [CGPoint], t: CGFloat) -> CGPoint
{
    if t < 0 || t > 1 { debugPrint("t should be between 0 and 1, not \(t)"); return CGPointZero }

    guard ps.count > 0 else { debugPrint("there should be some points, not \(ps.count)"); return CGPointZero }
    
    var Ps = ps
    var count = Ps.count - 1
    
    while count > 0
    {
        for i in 0 ..< count
        {
            Ps[i] = lerp(Ps[i], Ps[i+1], t)
        }
        
        count--
    }
    
    return Ps[0]
}

/**
Splits any order Bézier curve into two same order curves using [De Casteljau subdivision algoritm](https://en.wikipedia.org/wiki/De_Casteljau%27s_algorithm)
- parameter ps: points defining the curve, ps.first is begin point and ps.last is endPoint
- parameter t: percentage of distance traveled from begin point to end point
*/
public func splitBezierCurve(ps: [CGPoint], t: CGFloat = 0.5) -> [[CGPoint]]
{
    if t < 0 || t > 1 { debugPrint("t should be between 0 and 1, not \(t)"); return [] }
    
    switch ps.count
    {
    case 0 : debugPrint("there should be some points, not \(ps.count)"); return []
    case 1 : return [ps,ps]
    default:
     
    var arrays = [ps]

    while let Ps = arrays.last
    {
        if Ps.count < 2 { break }
        
        arrays.append(lerp(Ps, t: t))
    }
    
    return [arrays.map( { $0.first! } ), arrays.reverse().map( { $0.last! } ) ]
    }
}



/**
evaluate a point on a cubic Bézier curves using definition
- parameter a: begin point
- parameter b: control point 1
- parameter c: control point 2
- parameter d: end point
- parameter t: percentage of distance traveled from begin point to end point, defaults to 0.5
*/
public func cubicBezierPoint(a: CGPoint, b : CGPoint, c : CGPoint, d : CGPoint, t: CGFloat = 0.5) -> CGPoint
{
    return ((1 - t) * (1 - t) * (1 - t)) * a
        + 3 * ((1 - t) * (1 - t)) * t * b
        + 3 * (1 - t) * (t * t) * c
        + (t * t * t) * d
}

/**
evaluate a point on a quadratic Bézier curves using definition
- parameter a: begin point
- parameter b: control point 1
- parameter c: control point 2
- parameter d: end point
- parameter t: percentage of distance traveled from begin point to end point, defaults to 0.5
*/
public func quadraticBezierPoint(a: CGPoint, b : CGPoint, c : CGPoint, t: CGFloat = 0.5) -> CGPoint
{
    return (1 - t) * (1 - t) * a
        + 2 * (1 - t) * t * b
        + t * t * c
}
