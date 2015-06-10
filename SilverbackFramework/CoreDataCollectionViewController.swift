////
////  CoreDataCollectionViewController.swift
////  SilverbackFramework
////
////  Created by Christian Otkjær on 20/04/15.
////  Copyright (c) 2015 Christian Otkjær. All rights reserved.
////
//
//import Foundation
//import CoreData
//import UIKit
//
//public class CoreDataCollectionViewController: UICollectionViewController, SIFetchedResultsControllerHandlerDelegate
//{
//    public var handler : SIFetchedResultsControllerHandler?
//
//    public override func viewDidLoad()
//    {
//        super.viewDidLoad()
//    }
//    
//    public override func viewWillAppear(animated: Bool)
//    {
//        super.viewWillAppear(animated)
//        
//        collectionView?.reloadData()
//    }
//    
//    public override func viewDidAppear(animated: Bool)
//    {
//        super.viewDidAppear(animated)
//        
//        handler.errors.last?.1.presentInViewController(self)
//    }
//
//    
//    /*
//    // MARK: - Navigation
//    
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//    }
//    */
//    
//    // MARK: UICollectionViewDataSource
//    
//    override public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
//    {
//        return handler.numberOfSections
//    }
//    
//    override public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
//    {
//        return handler.numberOfEntitiesInSection(section)
//    }
//    
//    let CellReuseIdentifier = "Cell"
//    
//    override public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
//    {
//        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellReuseIdentifier, forIndexPath: indexPath) as! UICollectionViewCell
//        
//        if let entity = handler.entityAtIndexPath(indexPath)
//        {
//            configureCell(cell, inCollectionView: collectionView, atIndexPath: indexPath, forEntity: entity)
//        }
//        
//        return cell
//    }
//    
//    public func configureCell<T>(cell: UICollectionViewCell, inCollectionView collectionView: UICollectionView, atIndexPath indexPath: NSIndexPath, forEntity entity:T)
//    {
//        
//    }
//    
//    
//    // MARK: UICollectionViewDelegate
//    
//    /*
//    // Uncomment this method to specify if the specified item should be highlighted during tracking
//    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
//    return true
//    }
//    */
//    
//    /*
//    // Uncomment this method to specify if the specified item should be selected
//    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
//    return true
//    }
//    */
//    
//    /*
//    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
//    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
//    return false
//    }
//    
//    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
//    return false
//    }
//    
//    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
//    
//    }
//    */
//    
//    public func handler<T>(handler: SIFetchedResultsControllerHandler<T>, didMakeChanges changes: [SIFetchedResultsControllerHandlerChange<T>])
//    {
//        if let collectionView = self.collectionView
//        {
//            var deletedSectionIndicies = Set<Int>()
//            var insertedSectionIndicies = Set<Int>()
//            var deletedEntityPaths = Set<NSIndexPath>()
//            var insertedEntityPaths = Set<NSIndexPath>()
//            var movedEntityPaths = Array<(NSIndexPath, NSIndexPath)>()
//            var updatedEntityPaths = Set<NSIndexPath>()
//            
//            for change in changes
//            {
//                switch change
//                {
//                case .Delete(_, let path) : deletedEntityPaths.insert(path)
//                case .Insert(_, let path) : insertedEntityPaths.insert(path)
//                case .Update(_, let path) : updatedEntityPaths.insert(path)
//                case .Move(_, let fromPath, let toPath) : movedEntityPaths.append((fromPath, toPath))
//                    
//                case .DeleteSection(let section) : deletedSectionIndicies.insert(section)
//                case .InsertSection(let section) : insertedSectionIndicies.insert(section)
//                }
//            }
//            
//            if !movedEntityPaths.isEmpty
//            {
//                var remainingMoves: Array<(NSIndexPath,NSIndexPath)> = []
//                
//                for (fromIndexPath, toIndexPath) in movedEntityPaths
//                {
//                    if contains(deletedSectionIndicies, fromIndexPath.section)
//                    {
//                        if !contains(insertedSectionIndicies, toIndexPath.section)
//                        {
//                            insertedEntityPaths.insert(toIndexPath)
//                        }
//                    }
//                    else if contains(insertedSectionIndicies, toIndexPath.section)
//                    {
//                        if !contains(deletedSectionIndicies, toIndexPath.section)
//                        {
//                            deletedEntityPaths.insert(fromIndexPath)
//                        }
//                    }
//                    else
//                    {
//                        remainingMoves.append((fromIndexPath, toIndexPath))
//                    }
//                }
//                
//                movedEntityPaths = remainingMoves
//            }
//            
//            deletedEntityPaths = deletedEntityPaths.filter( { !contains(deletedSectionIndicies, $0.section) } )
//            insertedEntityPaths = insertedEntityPaths.filter( { !contains(insertedSectionIndicies, $0.section) } )
//            
//            collectionView.performBatchUpdates({
//                
//                // Sections
//                
//                
//                if !deletedSectionIndicies.isEmpty
//                {
//                    collectionView.deleteSections(NSIndexSet(indicies: Array(deletedSectionIndicies)))
//                }
//                
//                if !insertedSectionIndicies.isEmpty
//                {
//                    collectionView.insertSections(NSIndexSet(indicies: Array(insertedSectionIndicies)))
//                }
//                
//                // Items
//                
//                if !deletedEntityPaths.isEmpty
//                {
//                    collectionView.deleteItemsAtIndexPaths(Array(deletedEntityPaths))
//                }
//                
//                if !insertedEntityPaths.isEmpty
//                {
//                    collectionView.insertItemsAtIndexPaths(Array(insertedEntityPaths))
//                }
//                
//                if !updatedEntityPaths.isEmpty
//                {
//                    collectionView.reloadItemsAtIndexPaths(Array(updatedEntityPaths))
//                }
//                
//                if !movedEntityPaths.isEmpty
//                {
//                    for (fromEntityPath, toEntityPath) in movedEntityPaths
//                    {
//                        collectionView.moveItemAtIndexPath(fromEntityPath, toIndexPath: toEntityPath)
//                    }
//                }
//            }, completion: nil)
//        }
//    }
//    
//    public func handler<T>(handler: SIFetchedResultsControllerHandler<T>, didEncounterError error: NSError)
//    {
//        error.presentInViewController(self)
//    }
//}
//
