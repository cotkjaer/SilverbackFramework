//
//  CircleView.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 12/08/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import UIKit

public class CircleView: UIView
{
    override public func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool
    {
        // View will be "transparent" for touch events if we return 'false'
        return false
    }
    
    func setup()
    {
        self.updateBorder()
    }
    
    required public init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        setup()
    }
    
    override public var tintAdjustmentMode : UIViewTintAdjustmentMode { didSet { updateBorder() } }
    
    override public func tintColorDidChange()
    {
        super.tintColorDidChange()
        updateBorder()
    }
    
    func updateBorder()
    {
        var radius = min(bounds.size.width, bounds.size.height) / 2
        let lineWidth = radius / 15
        radius -= lineWidth / 2
        
        layer.borderColor = self.tintColor.CGColor
        layer.borderWidth = lineWidth
        layer.cornerRadius = radius
    }
    
    
    override public var bounds : CGRect { didSet { updateBorder() } }
}

