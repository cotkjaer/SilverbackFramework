//
//  NotificationManager.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 17/07/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import Foundation

/// A handler class to ease the bookkeeping associated with adding closure-based notification handling.
public class NotificationHandlerManager
{
    /// The tokens managed by this manager
    private var observerTokens = Array<AnyObject>()
    
    private let notificationCenter : NSNotificationCenter
    
    public required init(notificationCenter: NSNotificationCenter = NSNotificationCenter.defaultCenter())
    {
        self.notificationCenter = notificationCenter
    }
    
    deinit
    {
        deregisterAll()
    }
    
    public func deregisterAll()
    {
        while !observerTokens.isEmpty
        {
            notificationCenter.removeObserver(observerTokens.removeLast())
        }
    }
    
    public func registerHandlerForNotification(name: String? = nil,
        object: AnyObject? = nil,
        queue: NSOperationQueue? = nil,
        handler: ((notification: NSNotification) -> ()))
    {
        observerTokens.append(notificationCenter.addObserverForName(name, object: object, queue: queue, usingBlock: { handler(notification: $0) }))
    }
}

public func postNotificationNamed(name: String, object: AnyObject? = nil)
{
    NSNotificationCenter.defaultCenter().postNotificationName(name, object: object)
}

public func postNotificationNamed(name: String, object: AnyObject? = nil, keyValuePairs:(NSObject, AnyObject)...)
{
    var userInfo = Dictionary<NSObject, AnyObject>()
    
    for (key, value) in keyValuePairs
    {
        userInfo[key] = value
    }
    
    if userInfo.isEmpty
    {
        NSNotificationCenter.defaultCenter().postNotificationName(name, object: object)
    }
    else
    {
        NSNotificationCenter.defaultCenter().postNotificationName(name, object: object, userInfo: userInfo)
    }
}


