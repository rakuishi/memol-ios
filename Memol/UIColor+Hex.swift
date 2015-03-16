//
//  UIColor+Hex.swift
//  Memol
//
//  Created by OCHIISHI Koichiro on 2015/03/15.
//  Copyright (c) 2015年 OCHIISHI Koichiro. All rights reserved.
//

import UIKit

extension UIColor {

    convenience init(rgb: String) {
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0

        if rgb.hasPrefix("#") && countElements(rgb) == 7 {
            let index   = advance(rgb.startIndex, 1)
            let hex     = rgb.substringFromIndex(index)
            let scanner = NSScanner(string: hex)
            var hexValue: CUnsignedLongLong = 0
            if scanner.scanHexLongLong(&hexValue) {
                red   = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
                green = CGFloat((hexValue & 0x00FF00) >>  8) / 255.0
                blue  = CGFloat (hexValue & 0x0000FF)        / 255.0
            }
        }
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}