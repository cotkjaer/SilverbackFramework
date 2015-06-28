//
//  NSFetchedResultsControllerDelegate.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 29/04/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import Foundation
import CoreData
import UIKit

//public typealias TableViewCellUpdateHandler = (tableView:UITableView, indexPath:NSIndexPath, object:AnyObject) -> (Void)
//
//
//public class TableViewFetchControllerDelegate: NSFetchedResultsControllerDelegate
//{
//    private var sectionsBeingAddedInThisUpdatesBlock: [Int] = []
//    private var sectionsBeingDeletedInThisUpdatesBlock: [Int] = []
//    
//    private let tableView: UITableView
//    
//    /// invoked when a tableview cell is updated or moved
//    public var updateHandler: TableViewCellUpdateHandler?
//    
//    public var ignoreNextUpdates: Bool = false
//    
//    init(tableView: UITableView, updateHandler:TableViewCellUpdateHandler? = nil)
//    {
//        self.tableView = tableView
//        self.updateHandler = updateHandler
//    }
//    
//    public func controllerWillChangeContent(controller: NSFetchedResultsController)
//    {
//        if !ignoreNextUpdates
//        {
//            sectionsBeingAddedInThisUpdatesBlock.removeAll(keepCapacity: false)
//            sectionsBeingDeletedInThisUpdatesBlock.removeAll(keepCapacity: false)
//            tableView.beginUpdates()
//        }
//    }
//    
//    public func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType)
//    {
//        if !ignoreNextUpdates
//        {
//            switch type
//            {
//            case .Insert:
//                sectionsBeingAddedInThisUpdatesBlock.append(sectionIndex)
//                tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
//            case .Delete:
//                sectionsBeingDeletedInThisUpdatesBlock.append(sectionIndex)
//                self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
//            default:
//                return
//            }
//        }
//    }
//    
//    public func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?)
//    {
//        if !ignoreNextUpdates
//        {
//            switch type
//            {
//            case .Insert:
//                tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
//            case .Delete:
//                tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
//            case .Update:
//                updateHandler?(tableView: tableView, indexPath: indexPath!, object: anObject)
//            case .Move:
//                // Stupid and ugly, radar://17684030
//                if !contains(sectionsBeingAddedInThisUpdatesBlock, newIndexPath!.section) && !contains(sectionsBeingDeletedInThisUpdatesBlock, indexPath!.section)
//                {
//                    tableView.moveRowAtIndexPath(indexPath!, toIndexPath: newIndexPath!)
//                    
//                    //TODO: should be newIndexPath?
//                    updateHandler?(tableView: tableView, indexPath: indexPath!, object: anObject)
//                    //                    updateHandler?(cell: tableView.cellForRowAtIndexPath(indexPath!)!, object:anObject)
//                }
//                else
//                {
//                    tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
//                    tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
//                }
//            default:
//                return
//            }
//        }
//    }
//    
//    public func controllerDidChangeContent(controller: NSFetchedResultsController)
//    {
//        if ignoreNextUpdates
//        {
//            ignoreNextUpdates = false
//        }
//        else
//        {
//            sectionsBeingAddedInThisUpdatesBlock.removeAll(keepCapacity: false)
//            sectionsBeingDeletedInThisUpdatesBlock.removeAll(keepCapacity: false)
//            tableView.endUpdates()
//        }
//    }
//}
