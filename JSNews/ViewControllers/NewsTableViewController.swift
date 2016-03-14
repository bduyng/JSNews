//
//  NewsTableViewController.swift
//  JSNews
//
//  Created by Duy Bao Nguyen on 1/17/16.
//  Copyright © 2016 Duy Bao Nguyen. All rights reserved.
//

import UIKit
import SafariServices

let spinnerTag = Int.max - 2

class NewsTableViewController: UITableViewController, ArticlePresenter {
    
    let viewModel = ArticleListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Register TableViewCell
        self.tableView.registerReusableCell(ArticleTableViewCell.self)
        
        // Set footer view for table
        let footerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.tableView.frame.width, height: 50.0))
        
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        spinner.tag = spinnerTag
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        
        self.tableView.tableFooterView = footerView
        
        // Register viewModel delegate
        // Listen when the articles already fetched to update the table view
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
        
        // vertical magins
        var totalHeight = ArticleCellConstants.Margins.top +
            ArticleCellConstants.Margins.middle +
            ArticleCellConstants.Margins.bottom +
            ArticleCellConstants.separatorHeight
        
        // title height
        totalHeight += (Double)(article.title.heightWithConstrainedWidth(UIScreen.mainScreen().bounds.size.width - ArticleCellConstants.Margins.left - ArticleCellConstants.Margins.right, font: UIFont.systemFontOfSize(ArticleCellConstants.TextSize.title, weight: UIFontWeightMedium)))
        
        // subtitle height
        totalHeight += (Double)(article.username.heightWithConstrainedWidth(UIScreen.mainScreen().bounds.size.width - ArticleCellConstants.Margins.left - ArticleCellConstants.Margins.right, font: UIFont.systemFontOfSize(ArticleCellConstants.TextSize.subtitle, weight: UIFontWeightLight)))
        return (CGFloat)(totalHeight)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as ArticleTableViewCell
        
        let articleCellViewModel = ArticleViewModel(article: viewModel.articles[indexPath.row])
        cell.configure(withViewModel: articleCellViewModel)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == (viewModel.articles.count - 5) && viewModel.done {
            viewModel.fetchArticles("top")
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.openArticle(self.viewModel.articles[indexPath.row], tableView: tableView, indexPath: indexPath)
    }
}

// MARK: - ArticleListViewModelDelegate
extension NewsTableViewController: ArticleListViewModelDelegate {
    func didFetchedArticles(articles: [Article]) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
        })
        
        guard self.tableView.numberOfRowsInSection(0) != 0 else {
            self.tableView.reloadData()
            let spinner = self.tableView.tableFooterView?.viewWithTag(spinnerTag) as! UIActivityIndicatorView
            spinner.startAnimating()
            return
        }
        
        let insertedIndexPathRange = self.tableView.numberOfRowsInSection(0)..<articles.count
        let insertedIndexPaths = insertedIndexPathRange.map { NSIndexPath(forRow: $0, inSection: 0) }
        
        self.tableView.beginUpdates()
        self.tableView.insertRowsAtIndexPaths(insertedIndexPaths, withRowAnimation: .Fade)
        self.tableView.endUpdates()
    }
}