//
//  MenuButton.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 25/08/15.
//  Copyright © 2015 Christian Otkjær. All rights reserved.
//

import UIKit

public class MenuButton: UIButton
{
    let topBar = UIView()
    let middleBar = UIView()
    let bottomBar = UIView()
    
    func setup()
    {
        addSubview(topBar)
        addSubview(middleBar)
        addSubview(bottomBar)
        
        updateBarFrames()
        updateBarColors()
    }
    
    public override init(frame: CGRect)
    {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    override public var bounds : CGRect { didSet { updateBarFrames() } }
    
    func updateBarColors()
    {
        topBar.backgroundColor = tintColor
        middleBar.backgroundColor = tintColor
        bottomBar.backgroundColor = tintColor
    }
    
    private var barsBounds: CGRect { return UIEdgeInsetsInsetRect(bounds, contentEdgeInsets) }
    
    private var barSize : CGSize {
        let length = barsBounds.width
        return CGSize(width: length, height: max(2, ceil(length / 20)))
    }
    
    func updateBarFrames()
    {
        let barSize = self.barSize
        let barsRect = barsBounds
        
        topBar.frame = CGRect(origin: barsRect.topLeft, size: barSize)
        middleBar.frame = CGRect(center: barsRect.center, size: barSize)
        bottomBar.frame = CGRect(origin: barsRect.bottomLeft - CGPoint(x: 0, y: barSize.height), size: barSize)
    }
    
    public var open : Bool = true
        {
        didSet
        {
            if open
            {
                topBar.transform = CGAffineTransformIdentity
                middleBar.alpha = 1 //.transform = CGAffineTransformIdentity
                bottomBar.transform = CGAffineTransformIdentity
            }
            else
            {
                topBar.transform = CGAffineTransformRotate(CGAffineTransformMakeTranslation(0, bounds.center.y - topBar.center.y), π / 4)
                middleBar.alpha = 0 //.transform = CGAffineTransformMakeScale(0, 1)
                bottomBar.transform = CGAffineTransformRotate(CGAffineTransformMakeTranslation(0, bounds.center.y - bottomBar.center.y), -π / 4)
            }
        }
    }
}