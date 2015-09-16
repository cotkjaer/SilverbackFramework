//
//  UIBezierPath+Hex.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 02/07/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import UIKit

public extension UIBezierPath
{
    public convenience init(hexWithCenter center: CGPoint = CGPointZero, sideLength: CGFloat, orientation: HexOrientation = .Vertical)
    {
        self.init(convexRegularPolygonWithNumberOfSides: 6, center: center, circumscribedCircleRadius: sideLength, turned: orientation == HexOrientation.Vertical)
        
//        if orientation == .Vertical
//        {
//            self.init(convexRegularPolygonWithNumberOfSides: 6, center: center, radius: sideLength, turned: true)
//            
//            self.init()
//
//            let deltaY = 0.5 * sideLength
//            let deltaX = sin60 * sideLength
//            
//            moveToPoint(    CGPoint(x : center.x,               y : center.y - sideLength))
//            addLineToPoint( CGPoint(x : center.x + deltaX,      y : center.y - deltaY))
//            addLineToPoint( CGPoint(x : center.x + deltaX,      y : center.y + deltaY))
//            addLineToPoint( CGPoint(x : center.x,               y : center.y + sideLength))
//            addLineToPoint( CGPoint(x : center.x - deltaX,      y : center.y + deltaY))
//            addLineToPoint( CGPoint(x : center.x - deltaX,      y : center.y - deltaY))
//            closePath()

//        }
//        else
//        {
//            self.init(convexRegularPolygonWithNumberOfSides: 6, center: center, radius: sideLength)
        
//                        let deltaY = sin60 * sideLength
//                        let deltaX = 0.5 * sideLength
//            
//                        moveToPoint(    CGPoint(x : center.x - sideLength,   y : center.y))
//                        addLineToPoint( CGPoint(x : center.x - deltaX,       y : center.y - deltaY))
//                        addLineToPoint( CGPoint(x : center.x + deltaX,       y : center.y - deltaY))
//                        addLineToPoint( CGPoint(x : center.x + sideLength,   y : center.y))
//                        addLineToPoint( CGPoint(x : center.x + deltaX,       y : center.y + deltaY))
//                        addLineToPoint( CGPoint(x : center.x - deltaX,       y : center.y + deltaY))
//        }
        
    }
}
