//
//  NSFetchedResultsController.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 21/04/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import CoreData

public extension NSFetchedResultsController
{
    var sectionInfos : [NSFetchedResultsSectionInfo]
{ return (self.sections as? [NSFetchedResultsSectionInfo]) ?? [] }
    
    var numberOfSections : Int
{ return sectionInfos.count }
    
    func numberOfItemsInSection(section: Int) -> Int
{
        return numberOfObjectsInSection(section)
    }
    
    func numberOfRowsInSection(section: Int) -> Int
{
        return numberOfObjectsInSection(section)
    }
    
    func numberOfObjectsInSection(section: Int) -> Int
{
        return sectionInfoForSection(section)?.numberOfObjects ?? 0
    }
    
    func sectionInfoForSection(section: Int) -> NSFetchedResultsSectionInfo?
{
        if section >= 0 && section < sectionInfos.count
{
            return sectionInfos[section]
        }
        
        return nil
    }
}