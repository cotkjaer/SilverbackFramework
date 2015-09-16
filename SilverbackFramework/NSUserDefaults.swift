//
//  NSUserDefaults.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 16/07/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import Foundation

extension NSUserDefaults
{
    public func defaultSetting<V>(key: String, toValue value: V, force: Bool = false)
    {
        if !hasSetting(key) || force
        {
            setSetting(key, toValue: value, synchronize: true)
        }
    }
    
    private func hasSetting(key: String) -> Bool
    {
        return objectForKey(key) != nil
    }
    
    public func setSetting<V>(key: String, toValue value: V, synchronize : Bool = false)
    {
        if let string = value as? String
        {
            setObject(string, forKey: key)
        }
        else if let integer = value as? Int
        {
            setInteger(integer, forKey: key)
        }
        else if let bool = value as? Bool
        {
            setBool(bool, forKey: key)
        }
        else
        {
            preconditionFailure("Cannot handle setting \(value) with type \(value.dynamicType)")
        }
        
        if synchronize
        {
            self.synchronize()
        }
    }
    
    public func updateSetting<V: Equatable>(key: String, toValue value: V, synchronize : Bool = false) -> V?
    {
        precondition(hasSetting(key), "Attempt to update setting that is not present")
        
        if let currentValue = objectForKey(key) as? V
        {
            if currentValue != value
            {
                setSetting(key, toValue: value, synchronize: synchronize)
                return currentValue
            }
        }
        else
        {
            preconditionFailure("Current value is not of type \(V.self)")
        }
        
        return nil
    }
    
    public func getSetting<V>(key: String) -> V
    {
        precondition(hasSetting(key), "Attempt to get setting that is not present")
        
        if let value = objectForKey(key) as? V
        {
            return value
        }
        
        preconditionFailure("Setting for key \(key) is not of type \(V.self)")
    }
}
