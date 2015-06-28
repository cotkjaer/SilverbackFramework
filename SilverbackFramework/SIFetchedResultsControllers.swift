//
//  SIFetchedResultsControllers.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 03/06/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import Foundation
import CoreData
import UIKit

internal class SIFetchedResultsControllerWrapper: NSObject,  NSFetchedResultsControllerDelegate
{
    var errorClosure : ((NSError) -> ())?
    
    var willChangeClosure : (() -> ())?
    var didChangeClosure : (() -> ())?
    
    var insertedItemClosure : ((NSIndexPath) -> ())?
    var deletedItemClosure : ((NSIndexPath) -> ())?
    var updatedItemClosure : ((NSIndexPath) -> ())?
    var movedItemClosure : ((NSIndexPath, NSIndexPath) -> ())?
    
    var insertedSectionClosure : ((Int) -> ())?
    var deletedSectionClosure : ((Int) -> ())?
    
    var typ : NSManagedObject.Type? { didSet { updateFetchedResultsController() } }
    
    var managedObjectContext : NSManagedObjectContext! { didSet { updateFetchedResultsController() } }
    
    var sortDescriptors : [NSSortDescriptor] = []  { didSet { updateFetchedResultsController() } }
    
    var predicate: NSPredicate? { didSet { updateFetchedResultsController() } }
    
    var sectionNameKeyPath: String? { didSet { updateFetchedResultsController() } }
    
    private func updateFetchedResultsController()
    {
        if let entityType = typ
        {
            if managedObjectContext != nil
            {
                if !sortDescriptors.isEmpty
                {
                    if let entityDescription = NSEntityDescription.entityForName(entityType.entityName, inManagedObjectContext:managedObjectContext) as NSEntityDescription!
                    {
                        let fetchRequest = NSFetchRequest()
                        fetchRequest.entity = entityDescription
                        fetchRequest.sortDescriptors = self.sortDescriptors
                        fetchRequest.predicate = self.predicate
                        
                        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: self.sectionNameKeyPath, cacheName: nil)
                        
                        fetchedResultsController.delegate = self
                        
                        self.fetchedResultsController = fetchedResultsController
                    }
                    else
                    {
                        reportError(NSError(domain: "SIFetchedResultsControllerHandler", code: 1, description: "Could not create entity-description for \(entityType.entityName) in \(managedObjectContext)"))
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
                var error : NSError? = nil
                
                if !fController.performFetch(&error)
                {
                    reportError(NSError(domain: "SIFetchedResultsControllerHandler", code: 2, description: "Could not perform initial fetch for \(fController)", underlyingError: error))
                }
            }
        }
    }
    
    // MARK: - Lookup
    
    var sectionInfos : [NSFetchedResultsSectionInfo] { return (fetchedResultsController?.sections as? [NSFetchedResultsSectionInfo]) ?? [] }
    
    var numberOfSections : Int { return sectionInfos.count }
    
    func sectionInfoForSection(section: Int) -> NSFetchedResultsSectionInfo?
    {
        if section >= 0 && section < sectionInfos.count
        {
            return sectionInfos[section]
        }
        
        return nil
    }
    
    func numberOfEntitiesInSection(section: Int) -> Int
    {
        return sectionInfoForSection(section)?.numberOfObjects ?? 0
    }
    
    func entityAtIndexPath(path: NSIndexPath?) -> NSManagedObject?
    {
        if let indexPath = path
        {
            return fetchedResultsController?.objectAtIndexPath(indexPath) as? NSManagedObject
        }
        
        return nil
    }
    
    var sectionIndexTitles: [String] { return (fetchedResultsController?.sectionIndexTitles as? [String]) ?? [] }
    
    func sectionForSectionIndexTitle(title: String, atIndex index: Int) -> Int
    {
        return fetchedResultsController?.sectionForSectionIndexTitle(title, atIndex: index) ?? 0
    }
    
    //Mark: - Errors
    
    var errors: [(NSDate, NSError)] = []
    
    private func reportError(error: NSError)
    {
        let report = (NSDate(), error)
        
        errors.append(report)
        
        errorClosure?(error)
    }
    
    //MARK: - NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(controller: NSFetchedResultsController)
    {
        willChangeClosure?()
    }
    
    func controller(
        controller: NSFetchedResultsController,
        didChangeSection sectionInfo: NSFetchedResultsSectionInfo,
        atIndex sectionIndex: Int,
        forChangeType type: NSFetchedResultsChangeType
        )
    {
        switch type
        {
        case .Delete:
            deletedSectionClosure?(sectionIndex)
        case .Insert:
            insertedSectionClosure?(sectionIndex)
        case .Move:
            println("Ignored Move of section \(sectionIndex)")
        case .Update:
            println("Ignored Update of section \(sectionIndex)")
        }
    }
    
    func controller(
        controller: NSFetchedResultsController,
        didChangeObject anObject: AnyObject,
        atIndexPath indexPath: NSIndexPath?,
        forChangeType type: NSFetchedResultsChangeType,
        newIndexPath: NSIndexPath?
        )
    {
        switch type
        {
        case .Delete where indexPath != nil: deletedItemClosure?(indexPath!)
            
        case .Insert where newIndexPath != nil: insertedItemClosure?(newIndexPath!)
            
        case .Move where indexPath != nil && newIndexPath != nil: movedItemClosure?(indexPath!, newIndexPath!)
            
        case .Update where indexPath != nil: updatedItemClosure?(indexPath!)
            
        default:
            println("Bogus change of type \(type) with indexPath: \(indexPath) and \(newIndexPath)")
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController)
    {
        didChangeClosure?()
    }
}

public protocol SIFetchedResultsViewController
{
    var typ : NSManagedObject.Type? { get set }
    
    var managedObjectContext : NSManagedObjectContext! { get set }
    
    var sortDescriptors : [NSSortDescriptor] { get set }
    
    var predicate: NSPredicate? { get set }
    
    var sectionNameKeyPath: String? { get set }
    
    func objectAtIndexPath(path: NSIndexPath?) -> NSManagedObject?
}

// MARK: -  SIFetchedResultsTableViewController

public class SIFetchedResultsTableViewController: UITableViewController, SIFetchedResultsViewController
{
    private let wrapper = SIFetchedResultsControllerWrapper()
    
    public var typ : NSManagedObject.Type? {
        get { return wrapper.typ }
        set { wrapper.typ = newValue }
    }
    
    public var managedObjectContext : NSManagedObjectContext! {
        set { wrapper.managedObjectContext = newValue }
        get { return wrapper.managedObjectContext }
    }
    
    public var sortDescriptors : [NSSortDescriptor] {
        set { wrapper.sortDescriptors = newValue }
        get { return wrapper.sortDescriptors }
    }
    
    public var predicate: NSPredicate? {
        set { wrapper.predicate = newValue }
        get { return wrapper.predicate }
    }
    
    public var sectionNameKeyPath: String?
        {
        set { wrapper.sectionNameKeyPath = newValue }
        get { return wrapper.sectionNameKeyPath }
    }
    
    public override func viewDidLoad()
    {
        super.viewDidLoad()
        
        wrapper.errorClosure =
            {
                error in error.presentInViewController(self)
        }
        
        wrapper.willChangeClosure =
            {
                self.tableView.beginUpdates()
        }
        
        wrapper.insertedSectionClosure = { section in self.tableView.insertSections(NSIndexSet(index: section), withRowAnimation: .Automatic) }
        wrapper.deletedSectionClosure = { section in self.tableView.deleteSections(NSIndexSet(index: section), withRowAnimation: .Automatic) }
        
        wrapper.deletedItemClosure = { path in self.tableView.deleteRowsAtIndexPaths([path], withRowAnimation: .Automatic) }
        wrapper.insertedItemClosure = {
            path in self.tableView.insertRowsAtIndexPaths([path], withRowAnimation: .Automatic)
        }
        wrapper.updatedItemClosure = { path in self.tableView.reloadRowsAtIndexPaths([path], withRowAnimation: .Automatic) }
        wrapper.movedItemClosure = { fromPath, toPath in self.tableView.moveRowAtIndexPath(fromPath, toIndexPath: toPath) }
        
        wrapper.didChangeClosure = { self.tableView.endUpdates() }
    }
    
    public func objectAtIndexPath(path: NSIndexPath?) -> NSManagedObject?
    {
        return wrapper.entityAtIndexPath(path)
    }
    
    // MARK: UITableViewDataSource
    
    public override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return wrapper.numberOfSections
    }
    
    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return wrapper.numberOfEntitiesInSection(section)
    }
    
    public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let CellReuseIdentifier = "Cell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CellReuseIdentifier, forIndexPath: indexPath) as! UITableViewCell
        
        if let object = wrapper.entityAtIndexPath(indexPath)
        {
            configureCell(cell, inTableView: tableView, atIndexPath: indexPath, forObject:object)
        }
        
        return cell
    }
    
    public func configureCell(cell: UITableViewCell, inTableView tableView: UITableView, atIndexPath indexPath: NSIndexPath, forObject object:NSManagedObject)
    {
        //Override
    }

    public override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return wrapper.sectionInfoForSection(section)?.name
    }
    
    public override func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]!
    {
        return wrapper.sectionIndexTitles
    }
    
    public override func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int
    {
        return wrapper.sectionForSectionIndexTitle(title, atIndex: index)
    }
}

// MARK: -  SIFetchedResultsCollectionViewController

public class SIFetchedResultsCollectionViewController: UICollectionViewController, SIFetchedResultsViewController
{
    private let wrapper = SIFetchedResultsControllerWrapper()
    
    public var typ : NSManagedObject.Type? {
        get { return wrapper.typ }
        set { wrapper.typ = newValue }
    }
    
    public var managedObjectContext : NSManagedObjectContext! {
        set { wrapper.managedObjectContext = newValue }
        get { return wrapper.managedObjectContext }
    }
    
    public var sortDescriptors : [NSSortDescriptor] {
        set { wrapper.sortDescriptors = newValue }
        get { return wrapper.sortDescriptors }
    }
    
    public var predicate: NSPredicate? {
        set { wrapper.predicate = newValue }
        get { return wrapper.predicate }
    }
    
    public var sectionNameKeyPath: String?
        {
        set { wrapper.sectionNameKeyPath = newValue }
        get { return wrapper.sectionNameKeyPath }
    }
    
    private var insertedSections = [Int]()
    private var deletedSections = [Int]()
    
    private var insertedIndexPaths = [NSIndexPath]()
    private var deletedIndexPaths = [NSIndexPath]()
    private var updatedIndexPaths = [NSIndexPath]()
    private var movedIndexPaths = [(NSIndexPath, NSIndexPath)]()
    
    public override func viewDidLoad()
    {
        super.viewDidLoad()
        
        wrapper.errorClosure =
            {
                error in error.presentInViewController(self)
        }
        
        wrapper.willChangeClosure =
            {
                self.insertedIndexPaths.removeAll(keepCapacity: false)
                self.deletedIndexPaths.removeAll(keepCapacity: false)
                self.updatedIndexPaths.removeAll(keepCapacity: false)
                self.movedIndexPaths.removeAll(keepCapacity: false)
                
                self.insertedSections.removeAll(keepCapacity: false)
                self.deletedSections.removeAll(keepCapacity: false)
        }
        
        wrapper.insertedSectionClosure = { section in self.insertedSections.append(section) }
        wrapper.deletedSectionClosure = { section in self.deletedSections.append(section) }
        
        wrapper.deletedItemClosure = { path in self.deletedIndexPaths.append(path) }
        wrapper.insertedItemClosure = { path in self.insertedIndexPaths.append(path) }
        wrapper.updatedItemClosure = { path in self.updatedIndexPaths.append(path) }
        wrapper.movedItemClosure = { fromPath, toPath in self.movedIndexPaths.append((fromPath, toPath)) }
        
        wrapper.didChangeClosure = {
            
            if !self.movedIndexPaths.isEmpty
            {
                var remainingMoves: Array<(NSIndexPath,NSIndexPath)> = []
                
                for (fromIndexPath, toIndexPath) in self.movedIndexPaths
                {
                    if contains(self.deletedSections, fromIndexPath.section)
                    {
                        if !contains(self.insertedSections, toIndexPath.section)
                        {
                            if !contains(self.insertedIndexPaths, toIndexPath)
                            {
                                self.insertedIndexPaths.append(toIndexPath)
                            }
                        }
                    }
                    else if contains(self.insertedSections, toIndexPath.section)
                    {
                        if !contains(self.deletedIndexPaths, fromIndexPath)
                        {
                            self.deletedIndexPaths.append(fromIndexPath)
                        }
                    }
                    else
                    {
                        remainingMoves.append((fromIndexPath, toIndexPath))
                    }
                }
                
                self.movedIndexPaths = remainingMoves
            }
            
            self.deletedIndexPaths = filter(self.deletedIndexPaths) { !contains(self.deletedSections, $0.section)}
            self.insertedIndexPaths = filter(self.insertedIndexPaths) { !contains(self.insertedSections, $0.section)}
            
            self.collectionView?.performBatchUpdates(
                { //() -> Void in
                    
                    // Sections
                    
                    if !self.deletedSections.isEmpty
                    {
                        self.collectionView?.deleteSections(NSIndexSet(indicies: self.deletedSections))
                    }
                    
                    if !self.insertedSections.isEmpty
                    {
                        self.collectionView?.insertSections(NSIndexSet(indicies: self.insertedSections))
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

    public func objectAtIndexPath(path: NSIndexPath?) -> NSManagedObject?
    {
        return wrapper.entityAtIndexPath(path)
    }
    
    // MARK: UICollectionViewDataSource

    public override func numberOfSectionsInCollectionView(tableView: UICollectionView) -> Int
    {
        return wrapper.numberOfSections
    }
    
    public override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return wrapper.numberOfEntitiesInSection(section)
    }
    
    public override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        
        let CellReuseIdentifier = "Cell"
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellReuseIdentifier, forIndexPath: indexPath) as! UICollectionViewCell
        
        if let object = wrapper.entityAtIndexPath(indexPath)
        {
            configureCell(cell, inCollectionView: collectionView, atIndexPath: indexPath, forObject:object)
        }
        
        return cell
    }
    
    public func configureCell(cell: UICollectionViewCell, inCollectionView collectionView: UICollectionView, atIndexPath indexPath: NSIndexPath, forObject object:NSManagedObject)
    {
        //Override
    }
}