//
//  PagingCollectionViewFlowLayout.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 28/06/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import UIKit

class PagingCollectionViewFlowLayout: UICollectionViewFlowLayout
{
    init(flowLayout: UICollectionViewFlowLayout)
    {
        super.init()
        
        itemSize = flowLayout.itemSize
        sectionInset = flowLayout.sectionInset
        minimumLineSpacing = flowLayout.minimumLineSpacing
        minimumInteritemSpacing = flowLayout.minimumInteritemSpacing
        scrollDirection = flowLayout.scrollDirection
    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder:aDecoder)
    }
    
//    func applySelectedTransform(attributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes
//    {
//        if let selectedIndexPaths = collectionView?.indexPathsForSelectedItems() as? [NSIndexPath]
//        {
//            if find(selectedIndexPaths, attributes.indexPath) != nil
//            {
//                attributes.tr
//            }
//        }
//        
//        return attributes
//    }
//    
//    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]?
//    {
//        if let layoutAttributesList = super.layoutAttributesForElementsInRect(rect) as? [UICollectionViewLayoutAttributes]
//        {
//            return layoutAttributesList.map( self.applySelectedTransform )
//        }
//        
//        return nil
//    }
//    
//    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes!
//    {
//        let attributes = super.layoutAttributesForItemAtIndexPath(indexPath)
//        
//        return applySelectedTransform(attributes)
//    }
    
    // Mark : - Pagination
    var pageWidth : CGFloat { return itemSize.width + minimumLineSpacing }
    
    let flickVelocity : CGFloat = 0.3
    
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint
    {
        var contentOffset = proposedContentOffset
        
        if let collectionView = self.collectionView
        {
            let rawPageValue = collectionView.contentOffset.x / pageWidth
            
            let currentPage = velocity.x > 0 ? floor(rawPageValue) : ceil(rawPageValue)
            
            let nextPage = velocity.x > 0 ? ceil(rawPageValue) : floor(rawPageValue);
            
            let pannedLessThanAPage = abs(1 + currentPage - rawPageValue) > 0.5
            
            let flicked = abs(velocity.x) > flickVelocity
            
            if pannedLessThanAPage && flicked
            {
                contentOffset.x = nextPage * pageWidth
            }
            else
            {
                contentOffset.x = round(rawPageValue) * pageWidth
            }
        }
        
        return contentOffset
    }
}

