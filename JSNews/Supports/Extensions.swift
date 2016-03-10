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
    class func darkPrimaryColor() -> UIColor {
        return UIColor.hex("#C62828")
    }
    class func primaryColor() -> UIColor {
        return UIColor.hex("#E53935")
    }
    class func lightPrimaryColor() -> UIColor {
        return UIColor.hex("#FFEBEE")
    }
    
    class func secondaryColor(opacity: CGFloat = 1.0) -> UIColor {
        return UIColor(red: 237/255, green: 103/255, blue: 103/255, alpha: opacity)
    }
    
    class func hex(string: String) -> UIColor {
        var hex = string.hasPrefix("#")
            ? String(string.characters.dropFirst())
            : string
        
        guard hex.characters.count == 3 || hex.characters.count == 6 || hex.characters.count == 8
            else { return UIColor.whiteColor().colorWithAlphaComponent(0.0) }
        
        if hex.characters.count == 3 {
            for (index, char) in hex.characters.enumerate() {
                hex.insert(char, atIndex: hex.startIndex.advancedBy(index * 2))
            }
        }
        
        if hex.characters.count == 6 {
            hex = "FF" + hex
        }
        
        return UIColor(
            red:   CGFloat((Int(hex, radix: 16)! >> 16) & 0xFF) / 255.0,
            green: CGFloat((Int(hex, radix: 16)! >> 8) & 0xFF) / 255.0,
            blue:  CGFloat((Int(hex, radix: 16)! >> 0) & 0xFF) / 255.0,
            alpha: CGFloat((Int(hex, radix: 16)! >> 24) & 0xFF) / 255.0)
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

extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: ceil(width), height: CGFloat.max)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .ByWordWrapping
        
        let boundingBox = self.boundingRectWithSize(constraintRect,
            options: [NSStringDrawingOptions.UsesFontLeading, NSStringDrawingOptions.UsesLineFragmentOrigin],
            attributes: [
                NSFontAttributeName: font,
                NSParagraphStyleAttributeName: paragraphStyle
            ], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func indexOf(target: String) -> Int {
        let range = self.rangeOfString(target)
        if let range = range {
            return self.startIndex.distanceTo(range.startIndex)
        } else {
            return -1
        }
    }
    
    func fromNow() -> String {
        guard Double(self) != nil else {
            return "Invalid Date"
        }
        
        let from = NSDate(timeIntervalSince1970: Double(self)!)
        let now = NSDate()
        
        let cal = NSCalendar.currentCalendar()
        
        let components = cal.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: from, toDate: now, options: .MatchFirst)
        
        if components.year > 0 {
            let pluralSuffix = components.year == 1 ? "" : "s"
            return "\(components.year) year\(pluralSuffix) ago"
        }
        else if components.month > 0 {
            let pluralSuffix = components.month == 1 ? "" : "s"
            return "\(components.month) month\(pluralSuffix) ago"
        }
        else if components.day > 0 {
            let pluralSuffix = components.day == 1 ? "" : "s"
            return "\(components.day) day\(pluralSuffix) ago"
        }
        else if components.hour > 0 {
            let pluralSuffix = components.hour == 1 ? "" : "s"
            return "\(components.hour) hour\(pluralSuffix) ago"
        }
        else if components.minute > 0 {
            let pluralSuffix = components.minute == 1 ? "" : "s"
            return "\(components.minute) minute\(pluralSuffix) ago"
        }
        else if components.second > 0 {
            return "\(components.second) seconds ago"
        }
        else {
            return "Invalid Date"
        }
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