//
//  NSNumberFormatter.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 25/08/15.
//  Copyright © 2015 Christian Otkjær. All rights reserved.
//

import Foundation

public extension NSNumberFormatter
{
    public convenience init(numberStyle: NSNumberFormatterStyle)
    {
        self.init()
        self.numberStyle = numberStyle
    }
}
