//
//  ActivitiesTableViewController.swift
//  JSNews
//
//  Created by Duy Bao Nguyen on 2/28/16.
//  Copyright © 2016 Duy Bao Nguyen. All rights reserved.
//

import UIKit

struct ActivitiesConstants {
    static let highlighterTag = Int.max
    static let historyTitle = "History"
    static let bookmarkTitle = "Bookmark"
}

class ActivitiesTableViewController: UIViewController, ArticlePresenter {
    
    // MARK: Properties
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var bookmarkTableView: UITableView!
    
    let historyViewModel = ArticleListViewModel()
    let bookmarkViewModel = ArticleListViewModel()
    
    // MARK: View Life Cycle
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
        
        self.scrollView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        addCustomNavbar()
        
        historyViewModel.getVisitedArticles()
        self.historyTableView.reloadData()
        
        bookmarkViewModel.getBookmarkedArticles()
        self.bookmarkTableView.reloadData()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Convenience
    func getViewModelOf(tableView: UITableView) -> ArticleListViewModel {
        if (tableView == self.bookmarkTableView) {
            return bookmarkViewModel
        }
        return historyViewModel
    }
    
    func addCustomNavbar() {
        // Mimic navigation bar
        let navbar = UIView(frame: CGRect(x: 0.0, y: 20.0, width: UIScreen.mainScreen().bounds.size.width - 16.0, height: 44.0))
        
        // History title
        let historyTitle = UIButton(frame: CGRectZero)
        historyTitle.setTitle(ActivitiesConstants.historyTitle, forState: .Normal)
        historyTitle.titleLabel!.font = UIFont.systemFontOfSize(17.0, weight: UIFontWeightSemibold)
        historyTitle.titleLabel!.textColor = UIColor.whiteColor()
        historyTitle.sizeToFit()
        historyTitle.center = CGPoint(x: navbar.bounds.width / 4, y: navbar.bounds.height / 2)
        navbar.addSubview(historyTitle)
        
        historyTitle.addTarget(.TouchUpInside) {[unowned self] in
            var frame = self.scrollView.frame;
            frame.origin.x = 0;
            frame.origin.y = 0;
            self.scrollView.scrollRectToVisible(frame, animated: true)
        }
        
        // Bookmark title
        let bookmarkTitle = UIButton(frame: CGRectZero)
        bookmarkTitle.setTitle(ActivitiesConstants.bookmarkTitle, forState: .Normal)
        bookmarkTitle.titleLabel!.font = UIFont.systemFontOfSize(17.0, weight: UIFontWeightSemibold)
        bookmarkTitle.titleLabel!.textColor = UIColor.whiteColor()
        bookmarkTitle.sizeToFit()
        bookmarkTitle.center = CGPoint(x: 3 * navbar.bounds.width / 4, y: navbar.bounds.height / 2)
        navbar.addSubview(bookmarkTitle)
        
        bookmarkTitle.addTarget(.TouchUpInside) {[unowned self] in
            var frame = self.scrollView.frame;
            frame.origin.x = frame.size.width * 1.0;
            frame.origin.y = 0;
            self.scrollView.scrollRectToVisible(frame, animated: true)
        }
        
        // Highlighter
        let highlighter = UIView(frame: CGRect(x: 0.0, y: navbar.frame.height - 3.0, width: navbar.frame.width / 2.0, height: 3.0))
        highlighter.tag = ActivitiesConstants.highlighterTag
        highlighter.backgroundColor = UIColor.whiteColor()
        navbar.addSubview(highlighter)
        
        self.navigationItem.titleView = navbar
    }
}

// MARK: - UITableViewDataSource
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

// MARK: - UITableViewDelegate
extension ActivitiesTableViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let article = getViewModelOf(tableView).articles[indexPath.row]
        
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.openArticle(getViewModelOf(tableView).articles[indexPath.row], tableView: tableView, indexPath: indexPath)
    }
}

extension ActivitiesTableViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        guard let highlighter = self.navigationItem.titleView?.viewWithTag(ActivitiesConstants.highlighterTag) else { return }
        let delta = self.scrollView.contentOffset.x / (self.scrollView.contentSize.width / 2)
        
        if delta >= 0 && delta <= 1 {
            highlighter.frame.origin.x = delta * highlighter.frame.width
        }
//        else if delta < 0 {
//            delta = 1 + delta
//            highlighter.frame.size.width = (self.navigationItem.titleView?.frame.width)! / 2 * delta
//        }
//        else if delta > 1 {
//            delta = 2 - delta
//            var frame = highlighter.frame
//            frame.size.width = (self.navigationItem.titleView?.frame.width)! / 2 * delta
//            frame.origin.x = (self.navigationItem.titleView?.frame.width)! / 2 * delta
//            highlighter.frame = frame
//        }
    }
}