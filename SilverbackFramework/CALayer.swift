//
//  CALayer.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 20/04/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import UIKit

extension CALayer
{
    public var image : UIImage
    {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, opaque, 0)
        
        renderInContext(UIGraphicsGetCurrentContext())
        
        let image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext()
        
        return image
    }
}
