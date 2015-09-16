//
//  NSObject.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 21/04/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import Foundation

public extension NSObject
{
//    public class func baseName() -> String
//    {
//        let fullClassName = NSStringFromClass(object_getClass(self))
//        
//        let classNameComponents = split(fullClassName) { $0 == "." }
//        
//        return last(classNameComponents)!
//    }
//    
    public class var fullClassName : String { return "\(self)" }
    
    public class var baseClassName : String { return fullClassName.characters.split(isSeparator:  { $0 == "." }).map { String($0) }.last! }
}
