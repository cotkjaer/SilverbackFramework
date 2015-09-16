//
//  SKPaymentTransactionState.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 19/07/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import Foundation
import StoreKit

extension SKPaymentTransactionState : CustomStringConvertible
{
    public var description: String
        {
            switch self
            {
            case .Deferred:
                return "SKPaymentTransactionState.Deferred"
                
            case .Failed:
                return "SKPaymentTransactionState.Deferred"
                
            case .Purchased:
                return "SKPaymentTransactionState.Purchased"
                
            case .Purchasing:
                return "SKPaymentTransactionState.Purchasing"
                
            case .Restored:
                return "SKPaymentTransactionState.Restored"
            }
    }
}

extension SKPaymentTransactionState: Comparable
{
    private var compareValue : Int
        {
            switch self
            {
            case .Failed: return 0
                
            case .Deferred: return 1
                
            case .Purchasing: return 2
                
            case .Restored: return 3

            case .Purchased: return 4
            }
    }
}

public func < (lhs: SKPaymentTransactionState, rhs: SKPaymentTransactionState) -> Bool
{
    return lhs.compareValue < rhs.compareValue
}
