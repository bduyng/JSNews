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
let bSpinnerTag = Int.max - 3


// MARK: - NewsTableViewController
class NewsTableViewController: UIViewController, ArticlePresenter {
    
    // MARK: Properties
    let viewModel = ArticleListViewModel()
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        // Register TableViewCell
        self.tableView.registerReusableCell(ArticleTableViewCell.self)
        
        // Register viewModel delegate
        // Listen when the articles already fetched to update the table view
        viewModel.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        guard viewModel.articles.count == 0 else {
            return
        }
        
        // hide table view at the beginning
        self.tableView.alpha = 0.0
        self.tableView.hidden = true
        
        // Show big spinner at the beginning
        let bSpinner = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        bSpinner.color = UIColor.grayColor()
        bSpinner.tag = bSpinnerTag
        bSpinner.center = self.tableView.center
        self.view.insertSubview(bSpinner, belowSubview: self.tableView)
        bSpinner.startAnimating()
        
        // Set footer view for table
        setFooterView()
        
        // fetch articles
        viewModel.fetchArticles("top")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Convenience
    func setFooterView() {
        let footerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.tableView.frame.width, height: 50.0))
        
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        spinner.tag = spinnerTag
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        
        self.tableView.tableFooterView = footerView
    }
}

// MARK: - UITableViewDataSource
extension NewsTableViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.articles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as ArticleTableViewCell
        
        let articleCellViewModel = ArticleViewModel(article: viewModel.articles[indexPath.row])
        cell.configure(withViewModel: articleCellViewModel)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension NewsTableViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
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
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == (viewModel.articles.count - 5) && viewModel.done {
            viewModel.fetchArticles("top")
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.openArticle(self.viewModel.articles[indexPath.row], tableView: tableView, indexPath: indexPath)
    }
}

// MARK: - ArticleListViewModelDelegate
extension NewsTableViewController: ArticleListViewModelDelegate {
    func didFetchedArticles(articles: [Article]) {
        guard self.tableView.numberOfRowsInSection(0) != 0 else {
            // Reload data
            dispatch_async(dispatch_get_main_queue(), tableView.reloadData)
            
            // Start animating footer spinner
            let spinner = self.tableView.tableFooterView?.viewWithTag(spinnerTag) as! UIActivityIndicatorView
            spinner.startAnimating()
            
            // Show table view
            UIView.animateWithDuration(0.2, animations: {
                self.tableView.hidden = false
                self.tableView.alpha = 1.0
            }, completion:  { finished in
                    // Remove big spinner first
                    self.tableView.backgroundView?.viewWithTag(bSpinnerTag)?.removeFromSuperview()
            })
            
            return
        }
        
        let insertedIndexPathRange = self.tableView.numberOfRowsInSection(0)..<articles.count
        let insertedIndexPaths = insertedIndexPathRange.map { NSIndexPath(forRow: $0, inSection: 0) }
        
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.beginUpdates()
            self.tableView.insertRowsAtIndexPaths(insertedIndexPaths, withRowAnimation: .Automatic)
            self.tableView.endUpdates()
        })
    }
}