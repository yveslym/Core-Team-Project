//
//  Color Extension.swift
//  Core-Project
//
//  Created by Yveslym on 12/15/17.
//  Copyright © 2017 Yveslym. All rights reserved.
//

import Foundation
import UIKit
extension UIColor {
    
    public convenience init(hexString: String) {
        let hexString = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) as String
        let scanner = Scanner(string: hexString)
        
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red:red, green:green, blue:blue, alpha:0.5)
    }
    
    public func randomColor() -> UIColor{
        let color = UIColor.init(hexString: generateHexString())
        return color
    }
    
    private func generateHexString() -> String{
        let letters : NSString = "ABCDEF0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< 6 {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
}



















