//
//  NSManagedObject.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 21/04/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import CoreData

extension NSManagedObject
{
    public class var entityName: String
    {
        let fullClassName: String = NSStringFromClass(object_getClass(self))
        let classNameComponents: [String] = split(fullClassName) { $0 == "." }
        return classNameComponents.last!
    }
    
    public class func fetchRequest() -> NSFetchRequest
    {
        return NSFetchRequest(entityName: entityName)
    }
}
