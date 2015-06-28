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
    //    @IBInspectable public var cornerRadius: CGFloat
    //        {
    //        set { layer.cornerRadius = max(0,newValue); layer.masksToBounds = layer.cornerRadius > 0 }
    //        get { return layer.cornerRadius }
    //    }
    //
    //    @IBInspectable public var borderWidth: CGFloat
    //        {
    //        set { layer.borderWidth = newValue }
    //        get { return layer.borderWidth }
    //    }
    //
    //    @IBInspectable public var borderColor: UIColor?
    //        {
    //        set { layer.borderColor = newValue?.CGColor }
    //        get { return layer.borderColor != nil ? UIColor(CGColor: layer.borderColor) : nil }
    //    }
    
}

//MARK: - Animations
public extension UIView
{
    func bounce()
    {
        let options : UIViewAnimationOptions = .BeginFromCurrentState | .AllowUserInteraction
        
        transform = CGAffineTransformMakeScale(0.9, 0.9)
        
        UIView.animateWithDuration(1,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 2,
            options: options,
            animations:
            {
                self.transform = CGAffineTransformMakeScale(1, 1)
            }, completion: nil)
    }

    
    func attachPopUpAnimation()
    {
        let animation = CAKeyframeAnimation(keyPath: "transform")
        
        let scale1 = CATransform3DMakeScale(0.5, 0.5, 1)
        let scale2 = CATransform3DMakeScale(1.2, 1.2, 1);
        let scale3 = CATransform3DMakeScale(0.9, 0.9, 1);
        let scale4 = CATransform3DMakeScale(1.0, 1.0, 1);
        
        let frameValues =
        [
            NSValue(CATransform3D: scale1),
            NSValue(CATransform3D: scale2),
            NSValue(CATransform3D: scale3),
            NSValue(CATransform3D: scale4),
        ]
        
        animation.values = frameValues
        
        let frameTimes : [NSNumber] = [ 0, 0.5, 0.9, 1.0 ]
        
        animation.keyTimes = frameTimes
        
        animation.fillMode = kCAFillModeForwards
        animation.removedOnCompletion = false
        animation.duration = 0.2
        
        self.layer.addAnimation(animation, forKey: "popup")
    }
    
}