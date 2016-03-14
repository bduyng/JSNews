//
//  ArticlePresenter.swift
//  JSNews
//
//  Created by Duy Bao Nguyen on 3/5/16.
//  Copyright © 2016 Duy Bao Nguyen. All rights reserved.
//

//import Foundation
import UIKit
import SafariServices

struct ArticleCellConstants {
    static let separatorHeight = 0.5
    
    struct Margins {
        static let left:CGFloat = 15.0
        static let right: CGFloat = 15.0
        static let top = 10.0
        static let middle = 2.0
        static let bottom = 10.0
    }
    
    struct TextSize {
        static let title:CGFloat = CGFloat(UserSettings.TextSize)
        static let subtitle:CGFloat = CGFloat(UserSettings.TextSize - 2.0)
    }
}

protocol ArticlePresenter {
    func openArticle(article: Article, tableView: UITableView, indexPath: NSIndexPath)
}

extension ArticlePresenter where Self: UIViewController {
    func openArticle(article: Article, tableView: UITableView, indexPath: NSIndexPath) {
        guard article.url.indexOf("http") == 0 else {
            print("Error")
            print(article.url)
            return
        }
        
        let safariVC = SFSafariViewController(url: article.url)
        self.presentViewController(safariVC, animated: true, completion: {
            article.saveArticleIntoHistoryList()
        })
    }
}