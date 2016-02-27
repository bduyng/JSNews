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
        var totalHeight = 22.0
        
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
}