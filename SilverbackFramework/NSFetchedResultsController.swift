//
//  NSFetchedResultsController.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 21/04/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import CoreData

extension NSFetchedResultsController
{
    public var sectionInfos : [NSFetchedResultsSectionInfo] { return (self.sections as? [NSFetchedResultsSectionInfo]) ?? [] }
    
    public var numberOfSections : Int
    {
        return sectionInfos.count
        
//        if let sections = self.sections as? [NSFetchedResultsSectionInfo]
//        {
//            return sections.count
//        }
//        
//        return 0
    }

    public func numberOfItemsInSection(section: Int) -> Int
    {
        return numberOfObjectsInSection(section)
    }
    
    public func numberOfRowsInSection(section: Int) -> Int
    {
        return numberOfObjectsInSection(section)
    }
    
    public func numberOfObjectsInSection(section: Int) -> Int
    {
        return sectionInfoForSection(section)?.numberOfObjects ?? 0
        
//        if let sections = self.sections as? [NSFetchedResultsSectionInfo]
//        {
//            if section >= 0 && section < sectionInfos.count
//            {
//                return sectionInfos[section].numberOfObjects
//            }
//        }
        
//        return 0
    }
    
    public func sectionInfoForSection(section: Int) -> NSFetchedResultsSectionInfo?
    {
//        if let sections = self.sections as? [NSFetchedResultsSectionInfo]
//        {
            if section >= 0 && section < sectionInfos.count
            {
                return sectionInfos[section]
            }
//        }
        
        return nil
    }
}