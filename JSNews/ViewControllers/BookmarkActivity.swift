//
//  BookmarkActivity.swift
//  JSNews
//
//  Created by Duy Bao Nguyen on 3/18/16.
//  Copyright © 2016 Duy Bao Nguyen. All rights reserved.
//

import UIKit

class BookmarkActivity: UIActivity {
    
    var article:Article?
    
    convenience init(currentArticle: Article) {
        self.init()
        article = currentArticle
    }
    
    override func activityTitle() -> String? {
        return "Bookmark in JS News"
    }
    
    override func activityImage() -> UIImage? {
        return UIImage(named: "Bookmark")
    }
    
    override func prepareWithActivityItems(activityItems: [AnyObject]) {
        for item in activityItems {
            if item.isKindOfClass(Article) {
                article = item as? Article
            }
        }
    }
    
    override func performActivity() {
        guard article != nil else { return }
        article?.saveArticleIntoBookmarkList()
    }

}
