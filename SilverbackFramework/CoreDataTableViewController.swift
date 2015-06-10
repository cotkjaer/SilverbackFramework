//
//  CoreDataTableViewController.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 21/04/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import UIKit
import CoreData
import UIKit

public class CoreDataTableViewController: UITableViewController, NSFetchedResultsControllerDelegate
{
    public var error: NSError?
        {
        didSet { error?.presentInViewController(self) }
    }
    
    public var managedObjectContext : NSManagedObjectContext! { didSet { updateFetchedResultsController() } }
    
    public var entityName : String?  { didSet { updateFetchedResultsController() } }
    
    public var sortDescriptors : [NSSortDescriptor]?  { didSet { updateFetchedResultsController() } }
    
    public var sortDescriptor : NSSortDescriptor?
        {
        set { if newValue != nil { sortDescriptors = [newValue!] } else { sortDescriptors = nil } }
        get { return sortDescriptors?.last }
    }
    
    public var predicate: NSPredicate? { didSet { updateFetchedResultsController() } }
    
    public var sectionNameKeyPath: String? { didSet { updateFetchedResultsController() } }
    
    private func updateFetchedResultsController()
    {
        if managedObjectContext != nil
        {
            if sortDescriptors != nil
            {
                if let entityName = self.entityName as String!
                {
                    if let entityDescription = NSEntityDescription.entityForName(entityName, inManagedObjectContext:managedObjectContext) as NSEntityDescription!
                    {
                        let fetchRequest = NSFetchRequest()
                        fetchRequest.entity = entityDescription
                        fetchRequest.sortDescriptors = self.sortDescriptors
                        fetchRequest.predicate = self.predicate
                        
                        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: self.sectionNameKeyPath, cacheName: nil)
                        
                        fetchedResultsController.delegate = self
                        
                        self.fetchedResultsController = fetchedResultsController
                    }
                }
            }
        }
    }
    
    var fetchedResultsController: NSFetchedResultsController?
        {
        didSet
        {
            if let fController = fetchedResultsController as NSFetchedResultsController!
            {
                // perform initial model fetch
                
                if !fController.performFetch(&error)
                {
                    println("fetch error: \(error!.localizedDescription)")
                }
                else
                {
                    tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Lookup
    
    public func objectAtIndexPath(path: NSIndexPath) -> NSManagedObject?
    {
        return fetchedResultsController?.objectAtIndexPath(path) as? NSManagedObject
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: UITableViewDataSource
    
    override public func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return fetchedResultsController?.numberOfSections ?? super.numberOfSectionsInTableView(tableView)
    }
    
    override public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return fetchedResultsController?.numberOfRowsInSection(section) ?? super.tableView(tableView, numberOfRowsInSection: section)
    }
    
    let CellReuseIdentifier = "Cell"
    
    override public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        return tableView.dequeueReusableCellWithIdentifier(CellReuseIdentifier, forIndexPath: indexPath) as! UITableViewCell
    }
    
    public override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return fetchedResultsController?.sectionInfoForSection(section)?.name
    }
    
    public override func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]!
    {
        return fetchedResultsController?.sectionIndexTitles ?? []
    }
    
    public override func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int
    {
        return fetchedResultsController?.sectionForSectionIndexTitle(title, atIndex: index) ?? 0
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    
    
    public func controllerWillChangeContent(controller: NSFetchedResultsController)
    {
        tableView.beginUpdates()
    }
    
    public func controller(
        controller: NSFetchedResultsController,
        didChangeSection sectionInfo: NSFetchedResultsSectionInfo,
        atIndex sectionIndex: Int,
        forChangeType type: NSFetchedResultsChangeType
        )
    {
        switch type
        {
        case .Delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
        case .Insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
        case .Move:
            println("Ignored Move of section \(sectionIndex)")
        case .Update:
            println("Ignored Update of section \(sectionIndex)")
        }
    }
    
    public func controller(
        controller: NSFetchedResultsController,
        didChangeObject anObject: AnyObject,
        atIndexPath indexPath: NSIndexPath?,
        forChangeType type: NSFetchedResultsChangeType,
        newIndexPath: NSIndexPath?
        )
    {
        switch type
        {
        case .Delete where indexPath != nil:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
        case .Insert where newIndexPath != nil:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
        case .Move where indexPath != nil && newIndexPath != nil:
            tableView.moveRowAtIndexPath(indexPath!, toIndexPath: newIndexPath!)
        case .Update where indexPath != nil:
            tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
            
        default:
            println("Bogus change of type \(type) with indexPath: \(indexPath) and \(newIndexPath)")
        }
    }
    
    public func controllerDidChangeContent(controller: NSFetchedResultsController)
    {
        tableView.endUpdates()
    }
}
