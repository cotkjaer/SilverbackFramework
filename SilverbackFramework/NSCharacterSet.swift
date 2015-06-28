//
//  NSCharacterSet.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 20/04/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import Foundation

extension NSCharacterSet
{
    var characters : [Character]
{
        var chars : [Character] = []
        
        for var c : unichar = unichar.min; c < unichar.max; c++
{
            if characterIsMember(c)
{
                chars.append(Character(UnicodeScalar(c)))
            }
        }
        
        return chars
    }
}