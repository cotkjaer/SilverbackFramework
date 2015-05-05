//
//  NSString.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 20/04/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import Foundation

public extension NSString
{
    public var uppercaseFirstLetter: NSString?
    {
        if length > 0
        {
            return self.substringToIndex(1).uppercaseString
        }
        
        return nil
    }

}