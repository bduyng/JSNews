//
//  Article.swift
//  JSNews
//
//  Created by Duy Bao Nguyen on 1/25/16.
//  Copyright © 2016 Duy Bao Nguyen. All rights reserved.
//

import Foundation
import RealmSwift

class Article: Object {
    dynamic var down = ""
    dynamic var url = ""
    dynamic var up = ""
    dynamic var ctime = ""
    dynamic var id = ""
    dynamic var title = ""
    dynamic var username = ""
    dynamic var comments = ""
    
    dynamic var vtime: NSDate? = nil // visited time
    dynamic var btime: NSDate? = nil // bookmarked time
    
    func saveArticleIntoHistoryList() {
        // Get the default Realm
        let realm = try! Realm()
        
        // Persist your data easily
        try! realm.write {
            // Update vtime - visited time
            self.vtime = NSDate()
            realm.add(self, update: true)
        }
    }
    
    func saveArticleIntoBookmarkList() {
        // Get the default Realm
        let realm = try! Realm()
        
        // Persist your data easily
        try! realm.write {
            // Update btime - bookmark time
            self.btime = NSDate()
            realm.add(self, update: true)
        }
    }
    
    func removeArticleInBookmarkList() {
        // Get the default Realm
        let realm = try! Realm()
        
        // Persist your data easily
        try! realm.write {
            // Update btime - bookmark time
            self.btime = nil
            realm.add(self, update: true)
        }
    }
    
    
//    Specify properties to ignore (Realm won't persist these)
//    override static func ignoredProperties() -> [String] {
//        return []
//    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
