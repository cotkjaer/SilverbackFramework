//
//  UIViewController.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 20/04/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import UIKit

public extension UIApplication
{
    public class func topViewController(base: UIViewController? = UIApplication.sharedApplication().keyWindow?.rootViewController) -> UIViewController?
    {
        if let nav = base as? UINavigationController
        {
            return topViewController(nav.visibleViewController)
        }
        
        if let tab = base as? UITabBarController
        {
            if let selected = tab.selectedViewController
            {
                return topViewController(selected)
            }
        }
        
        if let presented = base?.presentedViewController
        {
            return topViewController(presented)
        }
        
        return base
    }
}

//MARK: - Navigation
public extension UIViewController
{
    public func dismissThisViewControllerAnimated(animated: Bool)
    {
        if let navigationController = self.navigationController
        {
            if navigationController.topViewController == self
            {
                navigationController.popViewControllerAnimated(animated)
            }
        }
        else if let presentingViewController = self.presentingViewController
        {
            presentingViewController.dismissViewControllerAnimated(animated, completion: nil)
        }
    }
}


typealias AlertActionHandler = (UIAlertAction!) -> (Void)

public func presentError(error: NSError?, inController controller:UIViewController, animated: Bool, completion: (() -> Void)?, handler errorHandler: (() -> Void)?) -> Bool
{
    if error != nil
    {
        let alertController = UIAlertController(title: error!.localizedDescription, message: error!.localizedRecoverySuggestion, preferredStyle: .Alert)
        
        let wrappedHandler: AlertActionHandler = { (alertAction: UIAlertAction!) in if errorHandler != nil { errorHandler!() } }
        
        let defaultAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .Default, handler: wrappedHandler)
        
        alertController.addAction(defaultAction)
        
        controller.presentViewController(alertController, animated: animated, completion: completion)
        
        return true
    }
    
    return false
}

extension UIViewController
{
    public func presentError(error: NSError?, animated: Bool, completion: (() -> Void)?, handler errorHandler: (() -> Void)?) -> Bool
    {
        if error != nil
        {
            let alertController = UIAlertController(title: error!.localizedDescription, message: error!.localizedRecoverySuggestion, preferredStyle: .Alert)
            
            let wrappedHandler: AlertActionHandler = { (alertAction: UIAlertAction!) in if errorHandler != nil { errorHandler!() } }
            
            let defaultAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .Default, handler: wrappedHandler)
            
            alertController.addAction(defaultAction)
            
            presentViewController(alertController, animated: animated, completion: completion)
            
            return true
        }
        
        return false
    }
}