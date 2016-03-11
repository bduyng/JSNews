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

protocol ArticlePresenter {
    func openArticle(article: Article, tableView: UITableView, indexPath: NSIndexPath)
}

extension ArticlePresenter where Self: UIViewController {
    func openArticle(article: Article, tableView: UITableView, indexPath: NSIndexPath) {
        if article.url.indexOf("http") == 0 {
            
            let defaults = NSUserDefaults.standardUserDefaults()
            
            let safariVC = SFSafariViewController(URL: NSURL(string: article.url)!, entersReaderIfAvailable: defaults.boolForKey("EnterReaderModeFirst"))
            safariVC.view.tintColor = UIColor.primaryColor()
            self.presentViewController(safariVC, animated: true, completion: {
                article.saveArticleIntoHistoryList()
            })
        }
        else {
            print("Error")
            print(article.url)
        }
    }
}