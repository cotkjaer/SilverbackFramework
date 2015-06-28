//
//  Element.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 21/04/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import Foundation
import CoreData

class Element: NSManagedObject
{

    @NSManaged var id: Int16
    @NSManaged var container: Container

}
