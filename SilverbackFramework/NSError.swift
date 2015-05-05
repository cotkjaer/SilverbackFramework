//
//  NSError.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 21/04/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import Foundation
import UIKit

extension NSError
{
    public convenience init(
        domain: String,
        code: Int,
        description: String? = nil,
        reason: String? = nil,
        underlyingError: NSError? = nil)
    {
        var errorUserInfo: [String : AnyObject] = [:]

        if description != nil
        {
            errorUserInfo[NSLocalizedDescriptionKey] = description ?? ""
        }
        if reason != nil
        {
            errorUserInfo[NSLocalizedFailureReasonErrorKey] = reason ?? ""
        }
        
        if underlyingError != nil
        {
            errorUserInfo[NSUnderlyingErrorKey] = underlyingError
        }
        
        self.init(domain: domain, code: code, userInfo: errorUserInfo)
    }
    
    public func presentInViewController(controller: UIViewController?)
    {
        let alertController = UIAlertController(title: self.localizedDescription, message: self.localizedFailureReason, preferredStyle: .Alert)
        
        //TODO: localizedRecoveryOptions and localizedRecoverySuggestion
        
        //        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
        //            // ...
        //        }
        //        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            abort()
        }
        alertController.addAction(OKAction)
        
        controller?.presentViewController(alertController, animated: true) { NSLog("Showing error: \(self)") }
    }
}