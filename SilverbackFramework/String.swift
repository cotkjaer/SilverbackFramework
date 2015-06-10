//
//  String.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 20/04/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import Foundation

extension String
{
    public var uppercaseFirstLetter: String?
        {
        get { if !isEmpty { return self[0].uppercaseString }; return nil }
    }
}

/// Subscript
extension String
{
    subscript (i: Int) -> Character
        {
            return self[advance(self.startIndex, i)]
    }
    
    subscript (i: Int) -> String
        {
            return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String
        {
            let startIndex = advance(self.startIndex, r.startIndex)
            let endIndex = advance(startIndex, r.endIndex - r.startIndex)
            
            return self[Range(start: startIndex, end: endIndex)]
            
            //        return substringWithRange(Range(start: advance(startIndex, r.startIndex), end: advance(startIndex, r.endIndex)))
    }
}
