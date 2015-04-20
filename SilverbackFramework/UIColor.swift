//
//  UIColor.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 20/04/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import UIKit

//MARK: - Random

extension UIColor
{
    public static func randomOpaqueColor() -> UIColor
    {
        return UIColor(
            red: CGFloat.random(lower: 0, upper: 1),
            green: CGFloat.random(lower: 0, upper: 1),
            blue: CGFloat.random(lower: 0, upper: 1),
            alpha: 1
        )
    }

    public static func randomColor() -> UIColor
    {
        return UIColor(
            red: CGFloat.random(lower: 0, upper: 1),
            green: CGFloat.random(lower: 0, upper: 1),
            blue: CGFloat.random(lower: 0, upper: 1),
            alpha: CGFloat.random(lower: 0, upper: 1)
        )
    }
}

//MARK: - Alpha

extension UIColor
{
    var alpha : CGFloat
    {
        var alpha : CGFloat = 0
        
        getWhite(nil, alpha: &alpha)
        
        return alpha
    }
    
    var opaque : Bool { return alpha > 0.999 }
}

//MARK: - Image

extension UIColor
{
    public var image: UIImage
    {
        let rect = CGRectMake(0, 0, 1, 1)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, opaque, 0)
        
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetFillColorWithColor(context, self.CGColor)
        CGContextFillRect(context, rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}