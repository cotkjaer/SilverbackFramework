//
//  ItemsDataSource.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 25/08/15.
//  Copyright © 2015 Christian Otkjær. All rights reserved.
//

import Foundation

public class ItemsDataSource<I: Equatable>
{
    //MARK: - Init
    
    public init(items: [[I]] = [])
    {
        self.items = items
    }
    
    //MARK: - Data
    
    public var items : [[I]]
    
    //MARK: - Public
    
    public var numberOfItemBlocks : Int { return items.count }
    
    func insertItem(item: I, atIndexPath path: NSIndexPath) -> Bool
    {
        if let itemsForSection = itemsForIndexPath(path)
        {
            if path.item >= 0 && path.item <= itemsForSection.count
            {
                var newItemsForSection = itemsForSection
                
                newItemsForSection.insert(item, atIndex: path.item)
                
                items[path.section] = newItemsForSection
                
                return true
            }
        }
        
        return false
    }
    
    public func itemsForIndexPath(indexPath: NSIndexPath) -> [I]?
    {
        return itemsInSection(indexPath.section)
    }
    
    public func itemsInSection(section: Int) -> [I]?
    {
        if section >= 0 && section < items.count
        {
            return items[section]
        }
        
        return nil
    }
    
    public func itemAtIndexPath(indexPath: NSIndexPath) -> I?
    {
        if let items = itemsInSection(indexPath.section)
        {
            if indexPath.item >= 0 && indexPath.item < items.count
            {
                return items[indexPath.item]
            }
        }
        return nil
    }
    
    public func indexPathForItem(item : I) -> NSIndexPath?
    {
        for sectionIndex in 0..<items.count
        {
            let items = self.items[sectionIndex]
            
            for itemIndex in 0..<items.count
            {
                if item == items[itemIndex]
                {
                    return NSIndexPath(forItem: itemIndex, inSection: sectionIndex)
                }
            }
        }
        
        return nil
    }
}