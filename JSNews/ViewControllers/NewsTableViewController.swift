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
        self.tableView.estimatedRowHeight = 100.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
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
        viewModel.fetchArticles("top")
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

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as ArticleTableViewCell
        
        let articleCellViewModel = ArticleViewModel(article: viewModel.articles[indexPath.row])
        cell.configure(withViewModel: articleCellViewModel)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == (viewModel.articles.count - 1) {
            viewModel.fetchArticles("top")
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.openArticle(self.viewModel.articles[indexPath.row])
    }
    
    func openArticle(article: Article) {
        // change url if the url is in the form text://
        // https://github.com/antirez/lamernews/blob/master/app.rb#L1655
        if article.url.lowercaseString.rangeOfString("text://") != nil {
            article.url = [Networking.host, "news", article.id].joinWithSeparator("/")
        }
        if let rangeOfHttpStr = String(article.url).rangeOfString("http") where rangeOfHttpStr.startIndex == String(article.url).startIndex {
            // open the article by wkwebview
            let webViewNavVC = storyboard?.instantiateViewControllerWithIdentifier("WebViewNavigationController") as! UINavigationController
            
            let webViewVC = webViewNavVC.viewControllers.first as! WKWebViewController
            webViewVC.url = article.url
            
            webViewNavVC.transitioningDelegate = self
            webViewNavVC.modalPresentationStyle = .Custom
            self.presentViewController(webViewNavVC, animated: true, completion: {
                
            })
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
            self.tableView.reloadData()
            
            // FIXME: Using beginUpdates is better than reloadData????
            
//            let insertedIndexPathRange = self.tableView.numberOfRowsInSection(0)..<self.viewModel.articles.count
//            let insertedIndexPaths = insertedIndexPathRange.map { NSIndexPath(forRow: $0, inSection: 0) }
//            
//            self.tableView.beginUpdates()
//            self.tableView.insertRowsAtIndexPaths(insertedIndexPaths, withRowAnimation: .Automatic)
//            self.tableView.endUpdates()
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
