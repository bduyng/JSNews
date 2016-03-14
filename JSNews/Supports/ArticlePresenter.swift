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
        guard article.url.indexOf("http") == 0 else {
            print("Error")
            print(article.url)
            return
        }
        
        let safariVC = SFSafariViewController(url: NSURL(string: article.url)!)
        self.presentViewController(safariVC, animated: true, completion: {
            article.saveArticleIntoHistoryList()
        })
    }
}