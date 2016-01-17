//
//  Extensions.swift
//  JSNews
//
//  Created by Duy Bao Nguyen on 1/12/16.
//  Copyright © 2016 Duy Bao Nguyen. All rights reserved.
//

import UIKit
import Foundation

// Define main colors

extension UIColor {
    class func primaryColor(opacity: CGFloat = 1.0) -> UIColor {
        return UIColor(red: 175/255, green: 29/255, blue: 29/255, alpha: opacity)
    }
    
    class func secondaryColor(opacity: CGFloat = 1.0) -> UIColor {
        return UIColor(red: 237/255, green: 103/255, blue: 103/255, alpha: opacity)
    }
}

// MARK: Using Generics to improve TableView cells
// Reference: http://alisoftware.github.io/swift/generics/2016/01/06/generic-tableviewcells/

protocol Reusable: class {
    static var reuseIdentifier: String { get }
    static var nib: UINib? { get }
}

extension Reusable {
    static var reuseIdentifier: String { return String(Self) }
    static var nib: UINib? { return nil }
}

extension UITableView {
    func registerReusableCell<T: UITableViewCell where T: Reusable>(_: T.Type) {
        if let nib = T.nib {
            self.registerNib(nib, forCellReuseIdentifier: T.reuseIdentifier)
        } else {
            self.registerClass(T.self, forCellReuseIdentifier: T.reuseIdentifier)
        }
    }
    
    func dequeueReusableCell<T: UITableViewCell where T: Reusable>(indexPath indexPath: NSIndexPath) -> T {
        return self.dequeueReusableCellWithIdentifier(T.reuseIdentifier, forIndexPath: indexPath) as! T
    }
    
    func registerReusableHeaderFooterView<T: UITableViewHeaderFooterView where T: Reusable>(_: T.Type) {
        if let nib = T.nib {
            self.registerNib(nib, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
        } else {
            self.registerClass(T.self, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
        }
    }
    
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView where T: Reusable>() -> T? {
        return self.dequeueReusableHeaderFooterViewWithIdentifier(T.reuseIdentifier) as! T?
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