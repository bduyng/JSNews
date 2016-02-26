//
//  NewsTableViewController.swift
//  JSNews
//
//  Created by Duy Bao Nguyen on 1/17/16.
//  Copyright © 2016 Duy Bao Nguyen. All rights reserved.
//

import UIKit
import SafariServices

class NewsTableViewController: UITableViewController {
    
    let viewModel = ArticleListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set dynamic height for TableViewCell
//        self.tableView.estimatedRowHeight = 100.0
//        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        // Hide separator on empty cells
        // FIXME: Hide separator on empty cells
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        // register TableViewCell
        self.tableView.registerReusableCell(ArticleTableViewCell.self)
        
        // register viewModel delegate
        // listen when the articles already fetched to update the table view
        viewModel.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if (viewModel.articles.count == 0) {
            viewModel.fetchArticles("top")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UITableViewDataSource

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.articles.count
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let article = self.viewModel.articles[indexPath.row]
        var totalHeight = 20.0
        
        // title height
        totalHeight += (Double)(article.title.heightWithConstrainedWidth(UIScreen.mainScreen().bounds.size.width - 30.0, font: UIFont.systemFontOfSize(17.0, weight: UIFontWeightMedium)))
        
        // subtitle height
        totalHeight += (Double)(article.username.heightWithConstrainedWidth(UIScreen.mainScreen().bounds.size.width - 30.0, font: UIFont.systemFontOfSize(14.0, weight: UIFontWeightLight)))
        return (CGFloat)(totalHeight) + 0.5 // plus separator height as well
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as ArticleTableViewCell
        
        let articleCellViewModel = ArticleViewModel(article: viewModel.articles[indexPath.row])
        cell.configure(withViewModel: articleCellViewModel)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == (viewModel.articles.count - 5) {
            viewModel.fetchArticles("top")
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.openArticle(self.viewModel.articles[indexPath.row], indexPath: indexPath)
    }
    
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
        }
        else {
            print("Error")
            print(article.url)
        }
    }
}

extension NewsTableViewController: ArticleListViewModelDelegate {
    func didFetchedArticles() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//            self.tableView.reloadData()
            
            // FIXME: Using beginUpdates is better than reloadData????
            
            let insertedIndexPathRange = self.tableView.numberOfRowsInSection(0)..<self.viewModel.articles.count
            let insertedIndexPaths = insertedIndexPathRange.map { NSIndexPath(forRow: $0, inSection: 0) }
            
            self.tableView.beginUpdates()
            self.tableView.insertRowsAtIndexPaths(insertedIndexPaths, withRowAnimation: .Fade)
            self.tableView.endUpdates()
        })
        
    }
}

extension NewsTableViewController: UIViewControllerTransitioningDelegate {
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let presentationAnimator = TransitionPresentationAnimator()
        return presentationAnimator
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let dismissalAnimator = TransitionDismissalAnimator()
        return dismissalAnimator
    }
}

extension NewsTableViewController: WKWebViewControllerDelegate {
    func didDismissWebView(indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}