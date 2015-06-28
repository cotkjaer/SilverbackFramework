//
//  NSFetchRequest.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 22/04/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import CoreData

extension NSFetchRequest
{
    public convenience init<T:NSManagedObject>(type:T.Type)
{
        self.init(entityName:type.entityName)
    }
}
