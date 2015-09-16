//
//  HexView.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 02/07/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import UIKit

public class HexView: UIView
{
    @IBInspectable public var hexOrientation : HexOrientation = .Vertical { didSet { if hexOrientation != oldValue { prepareHex() } } }
    
    
    @IBInspectable public var hexBorderColor: UIColor = UIColor.clearColor() { didSet { if hexBorderColor != oldValue { prepareHex() } } }

    @IBInspectable public var hexBorderWidth: CGFloat = 0 { didSet { if hexBorderWidth != oldValue { prepareHex() } } }

    
    override public var bounds : CGRect { didSet { if bounds != oldValue { prepareHex() } } }

    
    override public var frame : CGRect { didSet { if frame.size != oldValue.size { prepareHex() } } }

    /// returns true if the point (which must be in the views coordinate system) is inside (or on) the hex border
    public func containsPoint(point: CGPoint) -> Bool
    {
        return CGPathContainsPoint(hexShapeLayer.path, nil, point, false)
    }
    
    //MARK: private
    
    private lazy var hexSideLength : CGFloat = { return self.calcSideLength() }()
    
    private lazy var hexPath : UIBezierPath = { return UIBezierPath(hexWithCenter: self.bounds.center, sideLength: self.hexSideLength, orientation: self.hexOrientation) }()
    
    private let hexShapeLayer = CAShapeLayer()
    
    private func calcSideLength() -> CGFloat
    {
        switch hexOrientation
        {
        case .Horizontal: return bounds.size.width / 2
        case .Vertical: return bounds.size.height / 2
        }
    }
    
    private func prepareHex()
    {
        hexSideLength = calcSideLength()
        hexPath = UIBezierPath(hexWithCenter: bounds.center, sideLength: hexSideLength, orientation: hexOrientation)
        
        updateHexMask()

        if abs(hexBorderWidth) > 0.2 && hexBorderColor.alpha > 0.01
        {
        hexShapeLayer.path = UIBezierPath(hexWithCenter: bounds.center, sideLength: hexSideLength - hexBorderWidth / 2, orientation: hexOrientation).CGPath
        hexShapeLayer.lineWidth = hexBorderWidth
        hexShapeLayer.strokeColor = hexBorderColor.CGColor
        hexShapeLayer.fillColor = (backgroundColor ?? UIColor.clearColor()).CGColor
        
        layer.insertSublayer(hexShapeLayer, atIndex: 0)
        }
        else if hexShapeLayer.superlayer != nil
        {
            hexShapeLayer.removeFromSuperlayer()
        }
    }
    
    private func updateHexMask()
    {
//        let path = UIBezierPath(hexWithCenter: bounds.center, sideLength: sideLength, orientation: hexOrientation)
        
        if let maskLayer = layer.mask as? CAShapeLayer
        {
            maskLayer.path = hexPath.CGPath
        }
        else
        {
            let maskLayer = CAShapeLayer()
            maskLayer.path = hexPath.CGPath
            
            layer.mask = maskLayer
        }
    }
}
