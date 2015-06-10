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

public extension UIColor
{
    var alpha : CGFloat
    {
        var alpha : CGFloat = 0
        
        getWhite(nil, alpha: &alpha)
        
        return alpha
    }
    
    var opaque : Bool { return alpha > 0.999 }
}

//MARK: - HSB

public extension UIColor
{
    private var hsbComponents : (CGFloat, CGFloat, CGFloat, CGFloat)
        {
            var h : CGFloat = 0
            var s : CGFloat = 0
            var b : CGFloat = 0
            var a : CGFloat = 0
            
            getHue(&h, saturation: &s, brightness: &b, alpha: &a)
            
            return (h,s,b,a)
    }
    
    var hue: CGFloat
        {
            return hsbComponents.0
    }
    
    func withHue(hue: CGFloat) -> UIColor
    {
        let hsba = hsbComponents
        
        return UIColor(hue: hue, saturation: hsba.1, brightness: hsba.2, alpha: hsba.3)
    }
    
    var saturation: CGFloat
        {
            return hsbComponents.1
    }
    
    func withSaturation(saturation: CGFloat) -> UIColor
    {
        let hsba = hsbComponents
        
        return UIColor(hue: hsba.0, saturation: saturation, brightness: hsba.2, alpha: hsba.3)
    }
    
    var brightness: CGFloat
        {
            return hsbComponents.2
    }
    
    func withBrightness(brightness: CGFloat) -> UIColor
    {
        let hsba = hsbComponents
        
        return UIColor(hue: hsba.0, saturation: hsba.1, brightness: brightness, alpha: hsba.3)
    }
}

//MARK: - Brightness

public extension UIColor
{
    var isBright: Bool { return brightness > 0.75 }
    var isDark: Bool { return brightness < 0.25 }
    
    func brighterColor(factor: CGFloat = 0.2) -> UIColor
    {
        return withBrightness(brightness + (1 - brightness) * factor)
    }

    func darkerColor(factor: CGFloat = 0.2) -> UIColor
    {
        return withBrightness(brightness - (brightness) * factor)
    }
}

//MARK: - Image

public extension UIColor
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