//
//  UIView.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 09/06/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import Foundation

//MARK: - Nib
public extension UIView
{
    public class func loadFromNibNamed(nibName: String, bundle: NSBundle?) -> UIView?
    {
        return UINib(
            nibName: nibName,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil).first as? UIView
    }
}

//MARK: - Hierarchy
public extension UIView
{
    /**
        Ascends the super-view hierarchy until a view of the specified type is encountered
    
    - parameter type: the (super)type of superview to look for
    - returns: the first superview encountered that is of the specified type
    */
    func closestSuperViewOfType<T where T: UIView>(type: T.Type) -> T?
    {
        var views : [UIView] = []
        
        for var view = superview; view != nil; view = view?.superview
        {
            views.append(view!)
        }
        
        let ts = views.filter { $0 is T }
        
        return ts.first as? T
    }
    
    /**
    does a breadth-first search of the subviews hierarchy
    
    - parameter type: the (super)type of subviews to look for
    - returns: an array of subviews of the specified type
    */
    func closestSubViewsOfType<T where T: UIView>(type: T.Type) -> [T]
    {
        
        var views = subviews
        
        while !views.isEmpty
        {
            let ts = views.mapFilter({ $0 as? T})
            
            if !ts.isEmpty
            {
                return ts
            }

            views = views.reduce([], combine: { (subs, view) -> [UIView] in
                return subs + view.subviews
            })
        }
        
        return []
    }
}

//MARK: - Animations

public extension UIView
{
    func bounce()
    {
        let options : UIViewAnimationOptions = [.BeginFromCurrentState, .AllowUserInteraction]
        
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


