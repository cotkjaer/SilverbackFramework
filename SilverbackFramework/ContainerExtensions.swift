//
//  ContainerExtensions.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 21/04/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import CoreData

extension Container
{
    convenience init(context: NSManagedObjectContext)
{
        let entityDescription = NSEntityDescription.entityForName("Container", inManagedObjectContext: context)!
        self.init(entity: entityDescription, insertIntoManagedObjectContext: context)
    }
}