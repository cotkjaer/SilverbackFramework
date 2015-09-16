//
//  String.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 20/04/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import Foundation
import UIKit

public extension String
{
    init<T : UnsignedIntegerType>(_ v: T, radix: Int, uppercase: Bool = false, paddedToSize: Int)
    {
        self.init(v, radix: radix, uppercase: uppercase)
        
        let padSize = paddedToSize - self.characters.count
        
        if padSize > 0
        {
            self = String(Array<Character>(count: padSize, repeatedValue: "0")) + self
        }
    }
    
//    init(_ number: UInt8, radix: Int, paddedToSize: Int)
//    {
//        self.init(number, radix: radix)
//        
//        let padSize = paddedToSize - self.characters.count
//        
//        if padSize > 0
//        {
//            self = String(Array<Character>(count: padSize, repeatedValue: "0")) + self
//        }
//    }
}


public func trim(string: String) -> String
{
    return string.trimmed
}

public extension String
{
    public var trimmed : String
        {
            return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
}

public extension String
{
    public var uppercaseFirstLetter: String?
        {
        get
        { if !isEmpty
        { return self[0].uppercaseString }; return nil }
    }
}

/// Subscript
public extension String
{
    public subscript (i: Int) -> Character
        {
            return self[self.startIndex.advancedBy(i)]
    }
    
    public subscript (i: Int) -> String
        {
            return String(self[i] as Character)
    }
    
    public subscript (r: Range<Int>) -> String
        {
            let startIndex = self.startIndex.advancedBy(r.startIndex)
            let endIndex = startIndex.advancedBy(r.endIndex - r.startIndex)
            
            return self[Range(start: startIndex, end: endIndex)]
            
            //        return substringWithRange(Range(start: advance(startIndex, r.startIndex), end: advance(startIndex, r.endIndex)))
    }
}


public extension String
{
    public var reversed : String { return String(Array(self.characters.reverse())) }
}

public extension String
{
    public func sizeWithFont(font: UIFont) -> CGSize
    {
        let size: CGSize = self.sizeWithAttributes([NSFontAttributeName: font])
        
        return size
    }
}

public extension String
{
    public func beginsWith (str: String) -> Bool
    {
        if str.isEmpty
        {
            return true
        }
        
        if let range = rangeOfString(str)
        {
            return range.startIndex == self.startIndex
        }
        
        return false
    }
    
    public func endsWith (str: String) -> Bool
    {
        return reversed.beginsWith(str.reversed)
    }
}

extension String
{
    public func presentAsAlert(handler:(() -> Void)? = nil)
    {
        let alertController = UIAlertController(title: nil, message: self, preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            handler?()
        }
        
        alertController.addAction(OKAction)
        
        if let realController = UIApplication.topViewController()
        {
            realController.presentViewController(alertController, animated: true) { debugPrint("Showing error: \(self)") }
        }
        else
        {
            debugPrint("ERROR could not be presented: \(self)")
        }
    }
}