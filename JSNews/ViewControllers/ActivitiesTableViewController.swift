//
//  ActivitiesTableViewController.swift
//  JSNews
//
//  Created by Duy Bao Nguyen on 2/28/16.
//  Copyright © 2016 Duy Bao Nguyen. All rights reserved.
//

import UIKit

class ActivitiesTableViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var bookmarkTableView: UITableView!
    
    let historyViewModel = ArticleListViewModel()
    let bookmarkViewModel = ArticleListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // register TableViewCell
        self.historyTableView.registerReusableCell(ArticleTableViewCell.self)
        self.bookmarkTableView.registerReusableCell(ArticleTableViewCell.self)
        
        // Hide separator on empty cells
        self.historyTableView.tableFooterView = UIView(frame: CGRectZero)
        self.bookmarkTableView.tableFooterView = UIView(frame: CGRectZero)
        
        historyTableView.delegate = self
        historyTableView.dataSource = self
        
        bookmarkTableView.delegate = self
        bookmarkTableView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        historyViewModel.getSavedArticles()
        self.historyTableView.reloadData()
        
        bookmarkViewModel.getBookmarkedArticles()
        self.bookmarkTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getViewModelOf(tableView: UITableView) -> ArticleListViewModel {
        if (tableView == self.bookmarkTableView) {
            return bookmarkViewModel
        }
        return historyViewModel
    }
}

extension ActivitiesTableViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == self.historyTableView) {
            return historyViewModel.articles.count
        }
        else if (tableView == self.bookmarkTableView) {
            return bookmarkViewModel.articles.count
        }
        else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as ArticleTableViewCell
        let articleCellViewModel = ArticleViewModel(article: getViewModelOf(tableView).articles[indexPath.row])
        cell.configure(withViewModel: articleCellViewModel)
        
        return cell
    }
}

extension ActivitiesTableViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let article = getViewModelOf(tableView).articles[indexPath.row]
        var totalHeight = 22.0
        
        // title height
        totalHeight += (Double)(article.title.heightWithConstrainedWidth(UIScreen.mainScreen().bounds.size.width - 30.0, font: UIFont.systemFontOfSize(17.0, weight: UIFontWeightMedium)))
        
        // subtitle height
        totalHeight += (Double)(article.username.heightWithConstrainedWidth(UIScreen.mainScreen().bounds.size.width - 30.0, font: UIFont.systemFontOfSize(14.0, weight: UIFontWeightLight)))
        return (CGFloat)(totalHeight) + 0.5 // plus separator height as well
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //self.openArticle(self.viewModel.articles[indexPath.row], indexPath: indexPath)
    }
}
