//
//  RoundBorderedView.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 25/08/15.
//  Copyright © 2015 Christian Otkjær. All rights reserved.
//

import UIKit

@IBDesignable
public class RoundBorderedView: UIView
{
    @IBInspectable public var borderWidth: CGFloat
        {
        set { layer.borderWidth = newValue }
        get { return layer.borderWidth }
    }
    
    @IBInspectable public var borderColor: UIColor?
        {
        set { layer.borderColor = newValue?.CGColor }
        get { if let cgColor = layer.borderColor { return UIColor(CGColor: cgColor) } else { return nil } }
    }
    
    func setup()
    {
        updateBorder()
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
    
    public func updateBorder()
    {
        var radius = min(bounds.width, bounds.height) / 2
        let lineWidth = box(ceil(radius / 25), mi: 1, ma: 5)
        radius -= lineWidth / 2
        
        layer.borderColor = (self.borderColor ?? tintColor).CGColor
        layer.borderWidth = lineWidth
        layer.cornerRadius = radius
    }
    
    override public var bounds : CGRect { didSet { updateBorder() } }
    
    override public func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool
    {
        // View will be "transparent" for touch events if we return 'false'
        return UIBezierPath(ovalInRect: bounds).containsPoint(point)
    }
}
