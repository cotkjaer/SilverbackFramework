//
//  UICollectionView.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 02/06/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import UIKit

public extension UICollectionView
{
    func performBatchUpdates(updates: (() -> Void)?)
{
        performBatchUpdates(updates, completion: nil)
    }
}