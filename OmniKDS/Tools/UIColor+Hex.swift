//
//  UIColor+Hex.swift
//  OmniKDS
//
//  Created by Kumar Sharma on 21/01/20.
//  Copyright © 2020 Omni Systems. All rights reserved.
//

import Foundation
import UIKit

extension UIColor{
    
    //gets hex string from a Color object
    func toHex()->NSString{
        
        var r, g, b, a:CGFloat
        r=0;g=0;b=0;a=0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return NSString(format: "#%06x", rgb)
    }
    
    convenience init(hexString:String){
        
        let hexString:NSString = hexString.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) as NSString
        let scanner = Scanner.init(string: hexString as String)
        if hexString.hasPrefix("#"){
            scanner.scanLocation=1
        }
        var color:UInt64=0
        scanner.scanHexInt64(&color)
        let mask=0x000000FF
        let r=Int(color>>16) & mask
        let g=Int(color>>8) & mask
        let b=Int(color) & mask
        
        let red = CGFloat(r)/255.0
        let green=CGFloat(g)/255.0
        let blue=CGFloat(b)/255.0
        
        self.init(red:red, green:green, blue:blue, alpha:1)
    }
}
