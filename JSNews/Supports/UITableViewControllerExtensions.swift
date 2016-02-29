//
//  UITableViewControllerExtensions.swift
//  JSNews
//
//  Created by Duy Bao Nguyen on 2/27/16.
//  Copyright © 2016 Duy Bao Nguyen. All rights reserved.
//

import UIKit
import Foundation

extension UITableViewController: ArticleListViewModelDelegate {
    func didFetchedArticles(articles: [Article]) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let insertedIndexPathRange = self.tableView.numberOfRowsInSection(0)..<articles.count
            let insertedIndexPaths = insertedIndexPathRange.map { NSIndexPath(forRow: $0, inSection: 0) }
            
            self.tableView.beginUpdates()
            self.tableView.insertRowsAtIndexPaths(insertedIndexPaths, withRowAnimation: .Fade)
            self.tableView.endUpdates()
            
        })
        
    }
}

protocol ArticlePresenter {
    func openArticle(article: Article, indexPath: NSIndexPath)
}

extension UITableViewController: ArticlePresenter {
    func openArticle(article: Article, indexPath: NSIndexPath) {
        if let rangeOfHttpStr = String(article.url).rangeOfString("http") where rangeOfHttpStr.startIndex == String(article.url).startIndex {
            // open the article by wkwebview
            let webViewNavVC = storyboard?.instantiateViewControllerWithIdentifier("WebViewNavigationController") as! UINavigationController
            
            let webViewVC = webViewNavVC.viewControllers.first as! WKWebViewController
            webViewVC.url = article.url
            webViewVC.indexPath = indexPath
            webViewVC.delegate = self
            
            webViewNavVC.transitioningDelegate = self
            webViewNavVC.modalPresentationStyle = .Custom
            self.presentViewController(webViewNavVC, animated: true, completion: nil)
            
            article.saveArticleIntoHistoryList()
        }
        else {
            print("Error")
            print(article.url)
        }
    }
}

extension UITableViewController: WKWebViewControllerDelegate {
    func didDismissWebView(indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

extension UITableViewController: UIViewControllerTransitioningDelegate {
    public func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let presentationAnimator = TransitionPresentationAnimator()
        return presentationAnimator
    }
    
    public func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let dismissalAnimator = TransitionDismissalAnimator()
        return dismissalAnimator
    }
}