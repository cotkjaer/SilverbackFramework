//
//  ProductManager.swift
//  DinnerCalendar
//
//  Created by Christian Otkjær on 18/07/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import Foundation
import StoreKit

public extension SKProduct
{
    var localizedPrice : String?
        {
            let numberFormatter = NSNumberFormatter()
            
            numberFormatter.formatterBehavior = .Behavior10_4
            numberFormatter.numberStyle = .CurrencyStyle
            numberFormatter.locale = priceLocale
            
            return numberFormatter.stringFromNumber(price)
    }
}

private var productsCache = Dictionary<String, Product>()

public class Product: Equatable, Hashable
{
    public enum PurchaseStatus : Int, Comparable
    {
        case None = 0, PendingFetch, Purchasing, Deferred, Failed, Purchased
        
        init(transactionState: SKPaymentTransactionState?)
        {
            if let state = transactionState
            {
                switch state
                {
                case .Deferred : self = .Deferred
                case .Failed : self = .Failed
                case .Purchased, .Restored : self = .Purchased
                case .Purchasing : self = .Purchasing
                }
            }
            else
            {
                self = .None
            }
        }
    }
    
    public let productIdentifier : String
    internal var product: SKProduct?
    public var purchaseStatus : PurchaseStatus
        {
        didSet
        {
            // Only persist permanent status
            if purchaseStatus == .Purchased
            {
                NSUserDefaults.standardUserDefaults().setInteger(purchaseStatus.rawValue, forKey: productIdentifier)
                NSUserDefaults.standardUserDefaults().synchronize()
            }
        }
    }
    
    internal init(_ productIdentifier: String)
    {
        self.productIdentifier = productIdentifier
        self.purchaseStatus = PurchaseStatus(rawValue: NSUserDefaults.standardUserDefaults().integerForKey(productIdentifier)) ?? .None
    }
        
    public var localizedTitle : String {

        if let localizedTitle = product?.localizedTitle
        {
            if !localizedTitle.isEmpty
            {
                return localizedTitle
            }
        }
        return NSLocalizedString(productIdentifier, comment: "Product Identifier")
    }
    
    
    public var localizedDescription : String? { return product?.localizedDescription }
    public var localizedPrice : String? { return product?.localizedPrice }
    
    
    internal func advancePurchaseStatus(status: PurchaseStatus)
    {
        if status > purchaseStatus
        {
            purchaseStatus = status
        }
    }
    
    //MARK: Hashable
    
    public func purchase() throws
    {
        switch purchaseStatus
        {
        case .Deferred:
            throw NSError(domain: "In-App Purchase", code: 4, description: "Waiting for purchase to be approved")
            
        case .Purchased:
            throw NSError(domain: "In-App Purchase", code: 3, description: "Already purchased")
            
        case .Purchasing:
            throw NSError(domain: "In-App Purchase", code: 0, description: "Already in the process of purchasing")
            
        default:
            
            if !SKPaymentQueue.canMakePayments()
            {
                purchaseStatus >?= .Failed
                throw NSError(domain: "In-App Purchase", code: 1, description: "Cannot make payment", reason: "Payments are disables in Settings")
            }
            
            if let skProduct = product
            {
                purchaseStatus = .Purchasing
                SKPaymentQueue.defaultQueue().addPayment(SKPayment(product: skProduct))
            }
            else
            {
                purchaseStatus >?= .PendingFetch
            }
        }
    }
    
    //MARK: Hashable
    
    public var hashValue : Int { return productIdentifier.hashValue }
}

//MARK: - Factory
public extension Product
{
    public class func productWithIdentifier(identifier: String) -> Product
    {
        if let product = productsCache[identifier]
        {
            return product
        }
        else
        {
            let product = Product(identifier)
            productsCache[identifier] = product
            return product
        }
    }
}

public func ==(lhs: Product, rhs: Product) -> Bool
{
    return lhs.productIdentifier == rhs.productIdentifier
}

public func <(lhs: Product.PurchaseStatus, rhs: Product.PurchaseStatus) -> Bool
{
    return lhs.rawValue < rhs.rawValue
}

public let ProductsFetchSuccededNotificationName = "ProductsFetchSuccededNotification"
public let ProductsFetchFailedNotificationName = "ProductsFetchFailedNotification"
public let ProductsStatesUpdatedNotificationName = "ProductsStatesUpdatedNotification"
public let ProductsRestoreSuccededNotificationName = "ProductsRestoreSuccededNotification"
public let ProductsRestoreFailedNotificationName = "ProductsRestoreFailedNotification"

public enum ProductPurchaseStatus : Int, Comparable
{
    case None = 0, PendingFetch, Purchasing, Deferred, Failed, Purchased
    
    init(transactionState: SKPaymentTransactionState?)
    {
        if let state = transactionState
        {
            switch state
            {
            case .Deferred : self = .Deferred
            case .Failed : self = .Failed
            case .Purchased, .Restored : self = .Purchased
            case .Purchasing : self = .Purchasing
            }
        }
        else
        {
            self = .None
        }
    }
}

public func <(lhs: ProductPurchaseStatus, rhs: ProductPurchaseStatus) -> Bool
{
    return lhs.rawValue < rhs.rawValue
}

public class ProductManager: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver
{
    public let products : Set<Product>
   
    public required init(productIdentifiers: Set<String>)
    {
        products = productIdentifiers.map( { Product.productWithIdentifier($0) } )
        
        super.init()

        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
    }
    
    deinit
    {
        SKPaymentQueue.defaultQueue().removeTransactionObserver(self)
    }

    //MARK: - Lookup
    
    public func productWithIdentifier(identifier: String) -> Product?
    {
        return products.filter({ $0.productIdentifier == identifier }).first
    }
    
    //MARK: - SKProductsRequestDelegate

    private var allFetched : Bool { return products.filter({ $0.product == nil}).isEmpty }
    
    private var request : SKProductsRequest?
    
    private var fetching : Bool { return request != nil }

    public func fetchProducts()
    {
        if !fetching && !allFetched
        {
            request = SKProductsRequest(productIdentifiers: products.map( { $0.productIdentifier }))
            request?.delegate = self
            request?.start()
        }
    }
    
    public func request(request: SKRequest, didFailWithError error: NSError)
    {
        self.request = nil

        error.presentAsAlert()
        NSNotificationCenter.defaultCenter().postNotificationName(ProductsFetchFailedNotificationName, object: self)
    }
    
    public func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse)
    {
        self.request = nil
        
        if response.products.isEmpty
        {
            self.request(request, didFailWithError: NSError(domain: "dinner7days", code: 0, description: "No Products found, invalid identifiers: (" + response.invalidProductIdentifiers.joinWithSeparator(", ") + ")"))
        }
        else
        {
            for product in response.products
            {
                productWithIdentifier(product.productIdentifier)?.product = product
            }
            
            NSNotificationCenter.defaultCenter().postNotificationName(ProductsFetchSuccededNotificationName, object: self)
        }
        
        for product in products.filter( { $0.purchaseStatus == .PendingFetch })
        {
            product.purchaseStatus = .None
            tryCatchLog(product.purchase)
        }
    }
    
    //MARK: - SKPaymentTransactionObserver (restore)
    
    public var canRestore : Bool
        {
            if restored || restoring
            {
                return false
            }
            
            return !products.filter({ $0.purchaseStatus == .None }).isEmpty
    }
    
    public private(set) var restored = false
    
    public private(set) var restoring = false
    
    public func restoreProducts()
    {
        if canRestore//!restoring && !restored
        {
            restoring = true

            SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
        }
    }
    
    public func paymentQueue(queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: NSError)
    {
        restoring = false

        NSNotificationCenter.defaultCenter().postNotificationName(ProductsRestoreFailedNotificationName, object: self)

        error.presentAsAlert()
    }
    
    public func paymentQueueRestoreCompletedTransactionsFinished(queue: SKPaymentQueue)
    {
        restoring = false
        restored = true
        
        NSNotificationCenter.defaultCenter().postNotificationName(ProductsRestoreSuccededNotificationName, object: self)
    }
    
    //MARK: - SKPaymentTransactionObserver (purchase)

    public var purchasing : Bool { return !products.filter({ $0.purchaseStatus == .Purchasing }).isEmpty }
    
    public func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction])
    {
        for transaction in transactions
        {
            let id = transaction.payment.productIdentifier
            
            if let product = productWithIdentifier(id)
            {
                product.purchaseStatus >?= Product.PurchaseStatus(transactionState: transaction.transactionState)
                
                debugPrint("got transaction state \(transaction.transactionState) for product \(transaction.payment.productIdentifier)")
                
                switch transaction.transactionState
                {
                case .Deferred:
                    queue.finishTransaction(transaction)
                    
                case .Failed:
                    transaction.error?.presentAsAlert()
                    product.purchaseStatus = .None
                    queue.finishTransaction(transaction)
                    
                case .Purchased:
                    queue.finishTransaction(transaction)
                    
                case .Purchasing:
                    debugPrint(".Purchasing - not calling 'queue.finishTransaction(transaction)'")
                    
                case .Restored:
                    queue.finishTransaction(transaction)
                }
            }
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName(ProductsStatesUpdatedNotificationName, object: self)
    }
    
    public func paymentQueue(queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction])
    {
        debugPrint("Removed transactions \(transactions)")
    }
}

