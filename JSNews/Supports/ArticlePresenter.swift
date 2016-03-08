//
//  ArticlePresenter.swift
//  JSNews
//
//  Created by Duy Bao Nguyen on 3/5/16.
//  Copyright © 2016 Duy Bao Nguyen. All rights reserved.
//

import Foundation
import UIKit

protocol ArticlePresenter: WKWebViewControllerDelegate {
    func openArticle(article: Article, tableView: UITableView, indexPath: NSIndexPath)
}

extension ArticlePresenter {
    func didDismissWebView(tableView: UITableView, indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

extension ArticlePresenter where Self: UIViewController {
    func openArticle(article: Article, tableView: UITableView, indexPath: NSIndexPath) {
        if let rangeOfHttpStr = String(article.url).rangeOfString("http") where rangeOfHttpStr.startIndex == String(article.url).startIndex {
            // open the article by wkwebview
            let webViewNavVC = storyboard?.instantiateViewControllerWithIdentifier("WebViewNavigationController") as! UINavigationController
            
            let webViewVC = webViewNavVC.viewControllers.first as! WKWebViewController
            webViewVC.article = article
            webViewVC.tableView = tableView
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

extension UIViewController: UIViewControllerTransitioningDelegate {
    public func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let presentationAnimator = TransitionPresentationAnimator()
        return presentationAnimator
    }
    
    public func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let dismissalAnimator = TransitionDismissalAnimator()
        return dismissalAnimator
    }
}