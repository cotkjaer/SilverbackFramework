//
//  Foundation.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 20/04/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import Foundation

public func unwrap<T>(value: T?, defaultValue: T) -> T
{
    if let unwrappedValue = value
    {
        return unwrappedValue
    }
    else
    {
        return defaultValue
    }
}
