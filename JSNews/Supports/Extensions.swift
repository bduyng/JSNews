//
//  Extensions.swift
//  JSNews
//
//  Created by Duy Bao Nguyen on 1/12/16.
//  Copyright © 2016 Duy Bao Nguyen. All rights reserved.
//

import UIKit
import Foundation

extension UIColor {
    class func primaryColor(opacity: CGFloat = 1.0) -> UIColor {
        return UIColor(red: 175/255, green: 29/255, blue: 29/255, alpha: opacity)
    }
    
    class func secondaryColor(opacity: CGFloat = 1.0) -> UIColor {
        return UIColor(red: 237/255, green: 103/255, blue: 103/255, alpha: opacity)
    }
}

// MARK: ONLY FOR DEBUGGING
extension UIView {
    public func pbRecursiveDescription(depth:Int = 0) {
        let prefix = String(count: depth, repeatedValue: Character("-"))
        
        print( prefix + "\(self.dynamicType)(\(ObjectIdentifier(self).uintValue)):\(self.frame), \(self.center), \(self.bounds.origin)")
        
        for view in subviews {
            view.pbRecursiveDescription(depth + 1)
        }
    }
}