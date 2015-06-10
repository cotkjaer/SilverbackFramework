//
//  UIView.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 09/06/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import Foundation

public extension UIView
{
    @IBInspectable public var cornerRadius: CGFloat
        {
        set { layer.cornerRadius = max(0,newValue); layer.masksToBounds = layer.cornerRadius > 0 }
        get { return layer.cornerRadius }
    }
    
    @IBInspectable public var borderWidth: CGFloat
        {
        set { layer.borderWidth = newValue }
        get { return layer.borderWidth }
    }

    @IBInspectable public var borderColor: UIColor?
        {
        set { layer.borderColor = newValue?.CGColor }
        get { return layer.borderColor != nil ? UIColor(CGColor: layer.borderColor) : nil }
    }
}