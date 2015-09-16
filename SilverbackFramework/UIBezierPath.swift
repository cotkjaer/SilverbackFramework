//
//  UIBezierPath.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 17/08/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import UIKit

public extension UIBezierPath
{
    public convenience init(lineSegmentFrom a: CGPoint, to b: CGPoint)
    {
        self.init()

        moveToPoint(a)
        addLineToPoint(b)
    }
}

/// A Swiftified representation of a `CGPathElement`
///
/// Simpler and safer than `CGPathElement` because it doesn’t use a C array for the associated points.
public enum PathElement
{
    case MoveToPoint(CGPoint)
    case AddLineToPoint(CGPoint)
    case AddQuadCurveToPoint(CGPoint, CGPoint)
    case AddCurveToPoint(CGPoint, CGPoint, CGPoint)
    case CloseSubpath
    
    init(element: CGPathElement)
    {
        switch element.type
        {
        case .MoveToPoint:
            self = .MoveToPoint(element.points[0])
        case .AddLineToPoint:
            self = .AddLineToPoint(element.points[0])
        case .AddQuadCurveToPoint:
            self = .AddQuadCurveToPoint(element.points[0], element.points[1])
        case .AddCurveToPoint:
            self = .AddCurveToPoint(element.points[0], element.points[1], element.points[2])
        case .CloseSubpath:
            self = .CloseSubpath
        }
    }
}

extension PathElement : CustomDebugStringConvertible
{
    public var debugDescription: String
        {
            switch self
            {
            case let .MoveToPoint(point):
                return "\(point.x) \(point.y) moveto"
            case let .AddLineToPoint(point):
                return "\(point.x) \(point.y) lineto"
            case let .AddQuadCurveToPoint(point1, point2):
                return "\(point1.x) \(point1.y) \(point2.x) \(point2.y) quadcurveto"
            case let .AddCurveToPoint(point1, point2, point3):
                return "\(point1.x) \(point1.y) \(point2.x) \(point2.y) \(point3.x) \(point3.y) curveto"
            case .CloseSubpath:
                return "closepath"
            }
    }
}

extension PathElement : Equatable
{ }

public func ==(lhs: PathElement, rhs: PathElement) -> Bool
{
    switch(lhs, rhs)
    {
    case let (.MoveToPoint(l), .MoveToPoint(r)):
        return l == r
    case let (.AddLineToPoint(l), .AddLineToPoint(r)):
        return l == r
    case let (.AddQuadCurveToPoint(l1, l2), .AddQuadCurveToPoint(r1, r2)):
        return l1 == r1 && l2 == r2
    case let (.AddCurveToPoint(l1, l2, l3), .AddCurveToPoint(r1, r2, r3)):
        return l1 == r1 && l2 == r2 && l3 == r3
    case (.CloseSubpath, .CloseSubpath):
        return true
    case (_, _):
        return false
    }
}

//internal enum UIBezierPathSegment
//{
//    case Point(CGPoint)
//    case Line(CGPoint, CGPoint)
//    case QuadraticCurve(CGPoint, CGPoint, CGPoint)
//    case CubicCurve(CGPoint, CGPoint, CGPoint, CGPoint)
//    
//    init(element: PathElement, beginPoint:CGPoint, inout subPathBeginPoint: CGPoint)
//    {
//        switch element
//        {
//        case let .MoveToPoint(toPoint):
//            self = .Point(toPoint)
//            subPathBeginPoint = toPoint
//            
//        case let .AddLineToPoint(endPoint):
//            self = .Line(beginPoint, endPoint)
//            
//        case let .AddQuadCurveToPoint(ctrlPoint, endPoint):
//            self = .QuadraticCurve(beginPoint, ctrlPoint, endPoint)
//            
//        case let .AddCurveToPoint(ctrlPoint1, ctrlPoint2, endPoint):
//            self = .CubicCurve(beginPoint, ctrlPoint1, ctrlPoint2, endPoint)
//            
//        case .CloseSubpath:
//            self = .Line(beginPoint, subPathBeginPoint)
//        }
//    }
//    
//    var endPoint : CGPoint
//        {
//            switch self
//            {
//            case let .Point(point): return point
//                
//            case let .Line(_, endPoint): return endPoint
//                
//            case let .QuadraticCurve(_, _, endPoint): return endPoint
//                
//            case let .CubicCurve(_, _, _, endPoint): return endPoint
//            }
//    }
//    
//    var beginPoint : CGPoint
//        {
//            switch self
//            {
//            case let .Point(p): return p
//                
//            case let .Line(p, _): return p
//                
//            case let .QuadraticCurve(p, _, _): return p
//                
//            case let .CubicCurve(p, _, _, _): return p
//            }
//    }
//    
//    internal func pointForT(t: CGFloat) -> CGPoint
//    {
//        switch self
//        {
//        case let .Point(point): return point
//            
//        case let .Line(beginPoint, endPoint): return lerp(beginPoint, endPoint, t)
//            
//        case let .QuadraticCurve(beginPoint, controlPoint, endPoint): return quadraticBezierPoint(beginPoint, b: controlPoint, c: endPoint, t: t)
//            
//        case let .CubicCurve(beginPoint, ctrlPoint1, ctrlPoint2, endPoint): return cubicBezierPoint(beginPoint, b: ctrlPoint1, c: ctrlPoint2, d: endPoint, t: t)
//        }
//    }
//    
//    var length : CGFloat
//        {
//            switch self
//            {
//            case .Point(_): return 0
//                
//            case let .Line(beginPoint, endPoint): return endPoint.distanceTo(beginPoint)
//                
//            default:
//                repeat
//                {
//                    var approximation = endPoint.distanceTo(beginPoint)
//                    var segments = 2
//                    
//                    let points = Array(0...segments).map({ (segmentIndex) -> CGPoint in
//                        let t = CGFloat(segmentIndex) / CGFloat(segments)
//                        return self.pointForT(t)
//                    })
//                    
//                    let (length, _) = points.reduce((0, points[0]), combine: { (lengthAndPoint, point) -> (CGFloat, CGPoint) in
//                        let l = lengthAndPoint.1.distanceTo(point)
//                        return (l, point)
//                    })
//                    
//                    if abs(approximation - length) < 1 { return length }
//                    
//                    approximation = length
//                    segments *= 2
//                    
//                } while true
//            }
//    }
//}


extension UIBezierPath
{
    var curves: [BezierCurve]
        {
            var curves = [BezierCurve]()
            
            withUnsafeMutablePointer(&curves)
                { curvesPointer in
                    CGPathApply(CGPath, curvesPointer)
                        { (userInfo, nextElementPointer) in
                            
                            let curvesPointer = UnsafeMutablePointer<[BezierCurve]>(userInfo)
                            let curves = curvesPointer.memory
                            
                            let beginPoint = curves.last?.endPoint ?? CGPointZero
                            
                            var nextCurve : BezierCurve!
                            let element = nextElementPointer.memory
                            switch element.type
                            {
                            case .MoveToPoint:
                                nextCurve = BezierCurve(element.points[0])
                                
                            case .AddLineToPoint:
                                nextCurve = BezierCurve(beginPoint, element.points[0])
                                
                            case .AddQuadCurveToPoint:
                                nextCurve = BezierCurve(beginPoint, element.points[0], element.points[1])
                                
                            case .AddCurveToPoint:
                                nextCurve = BezierCurve(beginPoint, element.points[0], element.points[1], element.points[2])
                                
                            case .CloseSubpath:
                                let subpathBeginPoint = curves.filter({ $0.order == 1 }).last?.beginPoint ?? CGPointZero
                                
                                nextCurve = BezierCurve(beginPoint, subpathBeginPoint)
                            }
                            
                            curvesPointer.memory.append(nextCurve)
                    }
            }
            return curves
    }
    
//    var curves: [BezierCurve]
//        {
//            var curves = [BezierCurve]()
//            
//            withUnsafeMutablePointer(&curves)
//                { curvesPointer in
//                    CGPathApply(CGPath, curvesPointer)
//                        { (userInfo, nextElementPointer) in
//                            
//                            let curvesPointer = UnsafeMutablePointer<[BezierCurve]>(userInfo)
//                            let curves = curvesPointer.memory
//                            
//                            let beginPoint = curves.last?.endPoint ?? CGPointZero
//                            
//                            var nextCurve : BezierCurve!
//                            let element = nextElementPointer.memory
//                            switch element.type
//                            {
//                            case .MoveToPoint:
//                                nextCurve = .Point(element.points[0])
//                                
//                            case .AddLineToPoint:
//                                nextCurve = .Liniar(beginPoint, element.points[0])
//                                
//                            case .AddQuadCurveToPoint:
//                                nextCurve = .Quadratic(beginPoint, element.points[0], element.points[1])
//                                
//                            case .AddCurveToPoint:
//                                nextCurve = .Cubic(beginPoint, element.points[0], element.points[1], element.points[2])
//                                
//                            case .CloseSubpath:
//                                var subpathBeginPoint = CGPointZero
//                                
//                                for curve in curves.reverse()
//                                {
//                                    switch curve
//                                    {
//                                    case let .Point(p): subpathBeginPoint = p; break
//                                    default: continue
//                                    }
//                                }
//                                
//                                nextCurve = .Liniar(beginPoint, subpathBeginPoint)
//                            }
//                            
//                            curvesPointer.memory.append(nextCurve)
//                    }
//            }
//            return curves
//    }

//    var segments: [UIBezierPathSegment]
//        {
//            var s = Array<UIBezierPathSegment>()
//            
//            var subPathBeginPoint = CGPointZero
//            var beginPoint = CGPointZero
//            
//            for element in elements
//            {
//                let segment = UIBezierPathSegment(element: element, beginPoint: beginPoint, subPathBeginPoint: &subPathBeginPoint)
//                
//                beginPoint = segment.endPoint
//                
//                s.append(segment)
//            }
//            
//            return s
//    }
//    
    var length : CGFloat { return curves.reduce(0, combine: { $0 + $1.length } ) }
    
    var elements: [PathElement]
        {
            var pathElements = [PathElement]()
            withUnsafeMutablePointer(&pathElements)
                { elementsPointer in
                    CGPathApply(CGPath, elementsPointer)
                        { (userInfo, nextElementPointer) in
                            let nextElement = PathElement(element: nextElementPointer.memory)
                            let elementsPointer = UnsafeMutablePointer<[PathElement]>(userInfo)
                            elementsPointer.memory.append(nextElement)
                    }
            }
            return pathElements
    }
}



public extension UIBezierPath
{
    // Convert one element to BezierElement and save to array
    func GetBezierElements(info: Any, element: CGPathElement)
        
    {
        //    NSMutableArray *bezierElements = (__bridge NSMutableArray *)info;
        //    if (element)
        //    [bezierElements addObject:[BezierElement elementWithPathElement:*element]];
    }
    
    // Retrieve array of component elements
    func getElements()
        
    {
        //        let
        //        NSMutableArray *elements = [NSMutableArray array];
        //        CGPathApply(self.CGPath, (__bridge void *)elements, GetBezierElements);
        //        return elements;
        //
    }
    
    public func drawText(text: String, withFont font: UIFont)
    {
        //        var originalString: String = "Some text is just here..."
        //        let myString: NSString = originalString as NSString
        //        let size: CGSize = myString.sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(14.0)])
        //
        //        if text.isEmpty
        //        { return }
        //
        //        var context = UIGraphicsGetCurrentContext()
        //
        //        precondition(context != nil, "No context to draw into")
        //
        //
        //        if self.elements.count < 2
        //            {
        //            return
        //        }
        //
        //        var glyphDistance: Float = 0.0
        //        var lineLength: Float = self.pathLength
        //
        //        for var loc = 0; loc < string.length; loc++
        //                {
        //            var range: NSRange = NSMakeRange(loc, 1)
        //            var item: NSAttributedString = string.attributedSubstringFromRange(range)
        //            var bounding: CGRect = item.boundingRectWithSize(CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX), options: 0, context: nil)
        //            glyphDistance += bounding.size.width / 2
        //            var slope: CGPoint
        //            var percentConsumed: CGFloat = glyphDistance / lineLength
        //            var targetPoint: CGPoint = self.pointAtPercent(percentConsumed, withSlope: &slope)
        //            glyphDistance += bounding.size.width / 2
        //            if percentConsumed >= 1.0
        //                    {
        //
        //            }
        //            var angle: Float = atan(slope.y / slope.x)
        //            if slope.x < 0
        //                        {
        //                angle += M_PI
        //            }
        //            PushDraw({        CGContextTranslateCTM(context, targetPoint.x, targetPoint.y)
        //                CGContextRotateCTM(context, angle)
        //                CGContextTranslateCTM(context, -bounding.size.width / 2, -item.size.height / 2)
        //                item.drawAtPoint(CGPointZero)
        //
        //            })
        //        }
        
    }
}