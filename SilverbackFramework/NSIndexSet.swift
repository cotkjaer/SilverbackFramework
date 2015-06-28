//
//  NSIndexSet.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 20/04/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import Foundation

extension NSIndexSet
{
    public convenience init(indicies: Array<Int>)
{
        let mutableIndexSet = NSMutableIndexSet()
        
        for index in indicies
{
            mutableIndexSet.addIndex(index)
        }
        
        self.init(indexSet:mutableIndexSet)
    }
}

