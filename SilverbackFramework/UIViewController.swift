//
//  UIViewController.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 20/04/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import UIKit

typealias AlertActionHandler = (UIAlertAction!) -> (Void)

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