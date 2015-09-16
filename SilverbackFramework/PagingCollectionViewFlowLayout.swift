//
//  PagingCollectionViewFlowLayout.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 28/06/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import UIKit


public class PagingCollectionViewFlowLayout: UICollectionViewFlowLayout
{
    public init(flowLayout: UICollectionViewFlowLayout)
    {
        super.init()

        sectionInset = flowLayout.sectionInset

        itemSize = flowLayout.itemSize

        minimumLineSpacing = flowLayout.minimumLineSpacing
        minimumInteritemSpacing = flowLayout.minimumInteritemSpacing
        
        scrollDirection = flowLayout.scrollDirection
    }
    
    required public init?(coder aDecoder: NSCoder)
    {
        super.init(coder:aDecoder)
    }
    
    // MARK: - Prepare Layout
    
    public override func prepareLayout()
    {
        updateSectionInsets()
        
        super.prepareLayout()
    }
    
    // MARK: - Section Insets
    
    private func updateSectionInsets()
    {
        if let collectionView = self.collectionView
        {
            let gap = (collectionView.bounds.size - itemSize) / 2

            sectionInset = UIEdgeInsets(top: gap.height, left: gap.width, bottom: gap.height, right: gap.width)
        }
    }
    
    // Mark : - Pagination
    
    var pageSize : CGSize
        {
            switch scrollDirection
            {
            case .Horizontal: return itemSize + CGSize(width: minimumLineSpacing, height: minimumInteritemSpacing)
                
            case .Vertical: return itemSize + CGSize(width: minimumInteritemSpacing, height: minimumLineSpacing)
            }
    }

    var pageLength : CGFloat { return scrollDirection == .Horizontal ? itemSize.width : itemSize.height }

    var pageSpacing : CGFloat { return minimumLineSpacing }
    
    let flickVelocity : CGFloat = 0.3
    
    var onePageAtATime = true

    override public func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint
    {
        var contentOffset = proposedContentOffset
        
        if let collectionView = self.collectionView
        {
            if onePageAtATime && (velocity.distanceTo(CGPointZero) > flickVelocity)
            {
                let deltaX : CGFloat = velocity.x > 0 ? 0.5 : (velocity.x == 0 ? 0 : -0.5)
                let deltaY : CGFloat = velocity.y > 0 ? 0.5 : (velocity.y == 0 ? 0 : -0.5)
                let offsetOffset = CGPoint(x: pageSize.width * deltaX, y: pageSize.height * deltaY )
                
                contentOffset = collectionView.contentOffset + offsetOffset
            }
            
            let visibleRect = CGRect(origin: contentOffset, size: collectionView.bounds.size)
            
            let center = visibleRect.center

            if let attributesList = layoutAttributesForElementsInRect(visibleRect)
            {
                for attributes in attributesList
                {
                    if attributes.frame.contains(center)
                    {
                        return contentOffset - ( visibleRect.center - attributes.frame.center )
                    }
                }
            }
        }
        
        return contentOffset
    }
}

