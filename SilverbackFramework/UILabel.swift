//
//  UILabel.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 25/08/15.
//  Copyright © 2015 Christian Otkjær. All rights reserved.
//

import UIKit

public extension UILabel
{
    public var substituteFontName : String
        {
        get { return self.font.fontName }
        set { self.font = UIFont(name: newValue, size: self.font.pointSize) }
    }
}

public extension UILabel
{
    public convenience init(text: String, font: UIFont? = nil)
    {
        self.init(frame: CGRectZero)
        self.text = text
        if let alternateFont = font
        {
            self.font = alternateFont
        }
        self.sizeToFit()
    }
}
