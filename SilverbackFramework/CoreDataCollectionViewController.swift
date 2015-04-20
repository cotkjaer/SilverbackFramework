//
//  CoreDataCollectionViewController.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 20/04/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import Foundation
import CoreData

class CoreDataCollectionViewController: UICollectionViewController, NSFetchedResultsControllerDelegate
{
    var managedContext : NSManagedObjectContext?
        {
        didSet { updateFetchedResultsController() }
    }

    var entityName : String?
        {
        didSet { updateFetchedResultsController() }
    }
    
    private var sortDescriptors : [NSSortDescriptor]?
        {
        didSet { updateFetchedResultsController() }
    }
    
    var sortDescriptor : NSSortDescriptor?
        {
        set { if newValue != nil { sortDescriptors = [newValue!] } else { sortDescriptors = nil } }
        get { return sortDescriptors?.last }
    }
    
    private func updateFetchedResultsController()
    {
        if let managedContext = self.managedContext
        {
        
        if sortDescriptors != nil
        {
            if let entityName = self.entityName as String!
            {
                if let entityDescription = NSEntityDescription.entityForName(entityName, inManagedObjectContext:managedContext) as NSEntityDescription!
                {
                    let fetchRequest = NSFetchRequest()
                    fetchRequest.entity = entityDescription
                    fetchRequest.sortDescriptors = self.sortDescriptors
                    
                    let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
                    
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
                var error: NSError?
                
                if !fController.performFetch(&error)
                {
                    println("fetch error: \(error!.localizedDescription)")
                    abort();
                }
            }
        }
    }
    //    {
    //        let entity = NSEntityDescription.entityForName("Sunrise", inManagedObjectContext:self.managedContext)
    //        let daySort = NSSortDescriptor(key: "dayOfWeek16", ascending: true)
    //        let req = NSFetchRequest()
    //        req.entity = entity
    //        req.sortDescriptors = [daySort]
    //
    //        let fetchedResultsController = NSFetchedResultsController(fetchRequest: req, managedObjectContext: self.managedContext, sectionNameKeyPath: nil, cacheName: nil)
    //
    //        fetchedResultsController.delegate = self
    //
    //        return fetchedResultsController
    //
    //        }()
    
    //    override func viewDidLoad()
    //    {
    //        super.viewDidLoad()
    //
    //        // perform initial model fetch
    //        var error: NSError?
    //
    //        if !fetchedResultsController!.performFetch(&error)
    //        {
    //            println("fetch error: \(error!.localizedDescription)")
    //            abort();
    //        }
    //    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        if let sections = fetchedResultsController?.sections as? [NSFetchedResultsSectionInfo]
        {
            return sections.count
        }
        
        return 0
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if let sections = fetchedResultsController?.sections as? [NSFetchedResultsSectionInfo]
        {
            if section >= 0 && section < sections.count
            {
                return sections[section].numberOfObjects
            }
        }
        
        return 0
    }
    
    let CellReuseIdentifier = "Cell"
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        //        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellReuseIdentifier, forIndexPath: indexPath) as? SunrisesCollectionViewCell
        //        {
        //            if let sunrise = fetchedResultsController?.objectAtIndexPath(indexPath) as? Sunrise
        //            {
        //                cell.dayOfWeekLabel?.text = sunrise.weekDaySymbol
        //                cell.sunView.alpha = sunrise.enabled ? 1.0 : 0.2
        //            }
        //
        //            return cell
        //        }
        
        return collectionView.dequeueReusableCellWithReuseIdentifier(CellReuseIdentifier, forIndexPath: indexPath) as! UICollectionViewCell
    }
    
    // MARK: UICollectionViewDelegate
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
    }
    */
    
    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
    }
    */
    
    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return false
    }
    
    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
    return false
    }
    
    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    var deletedIndexPaths: Array<NSIndexPath> = []
    var insertedIndexPaths: Array<NSIndexPath> = []
    var updatedIndexPaths: Array<NSIndexPath> = []
    var movedIndexPaths: Array<(NSIndexPath,NSIndexPath)> = []
    
    var deletedSectionIndicies: Array<Int> = []
    var insertedSectionIndicies: Array<Int> = []
    
    
    func controllerWillChangeContent(controller: NSFetchedResultsController)
    {
        deletedIndexPaths.removeAll(keepCapacity: false)
        insertedIndexPaths.removeAll(keepCapacity: false)
        movedIndexPaths.removeAll(keepCapacity: false)
        updatedIndexPaths.removeAll(keepCapacity: false)
        deletedSectionIndicies.removeAll(keepCapacity: false)
        insertedSectionIndicies.removeAll(keepCapacity: false)
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType)
    {
        switch type
        {
        case .Delete:
            deletedSectionIndicies.append(sectionIndex)
        case .Insert:
            insertedSectionIndicies.append(sectionIndex)
        case .Move:
            println("Ignored Move of section \(sectionIndex)")
        case .Update:
            println("Ignored Update of section \(sectionIndex)")
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?)
    {
        switch type
        {
        case .Delete where indexPath != nil:
            deletedIndexPaths.append(indexPath!)
        case .Insert where newIndexPath != nil:
            insertedIndexPaths.append(newIndexPath!)
        case .Move where indexPath != nil && newIndexPath != nil:
            movedIndexPaths.append((indexPath!, newIndexPath!))
        case .Update where indexPath != nil:
            updatedIndexPaths.append(indexPath!)
            
        default:
            println("Bogus change of type \(type) with indexPaht: \(indexPath) and \(newIndexPath)")
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController)
    {
        if !movedIndexPaths.isEmpty
        {
            var remainingMoves: Array<(NSIndexPath,NSIndexPath)> = []
            
            for (fromIndexPath, toIndexPath) in movedIndexPaths
            {
                if contains(deletedSectionIndicies, fromIndexPath.section)
                {
                    if !contains(insertedSectionIndicies, toIndexPath.section)
                    {
                        if !contains(insertedIndexPaths, toIndexPath)
                        {
                            insertedIndexPaths.append(toIndexPath)
                        }
                    }
                }
                else if contains(insertedSectionIndicies, toIndexPath.section)
                {
                    if !contains(deletedIndexPaths, fromIndexPath)
                    {
                        deletedIndexPaths.append(fromIndexPath)
                    }
                }
                else
                {
                    remainingMoves.append((fromIndexPath, toIndexPath))
                }
            }
            
            movedIndexPaths = remainingMoves
            
        }
        
        deletedIndexPaths = filter(deletedIndexPaths) { return !contains(self.deletedSectionIndicies, $0.section)}
        insertedIndexPaths = filter(insertedIndexPaths) { return !contains(self.insertedSectionIndicies, $0.section)}
        
        
        self.collectionView?.performBatchUpdates(
            { () -> Void in
                
                // Sections
                
                if !self.deletedSectionIndicies.isEmpty
                {
                    self.collectionView?.deleteSections(NSIndexSet(indicies: self.deletedSectionIndicies))
                }
                
                if !self.insertedSectionIndicies.isEmpty
                {
                    self.collectionView?.insertSections(NSIndexSet(indicies: self.insertedSectionIndicies))
                }
                
                // Items
                
                if !self.deletedIndexPaths.isEmpty
                {
                    self.collectionView?.deleteItemsAtIndexPaths(self.deletedIndexPaths)
                }
                
                if !self.insertedIndexPaths.isEmpty
                {
                    self.collectionView?.insertItemsAtIndexPaths(self.insertedIndexPaths)
                }
                
                if !self.updatedIndexPaths.isEmpty
                {
                    self.collectionView?.reloadItemsAtIndexPaths(self.updatedIndexPaths)
                }
                
                if !self.movedIndexPaths.isEmpty
                {
                    for (fromIndexPath, toIndexPath) in self.movedIndexPaths
                    {
                        self.collectionView?.moveItemAtIndexPath(fromIndexPath, toIndexPath: toIndexPath)
                    }
                }
                
            }, completion: nil)
        
    }
    
}
