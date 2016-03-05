//
//  ActivitiesTableViewController.swift
//  JSNews
//
//  Created by Duy Bao Nguyen on 2/28/16.
//  Copyright © 2016 Duy Bao Nguyen. All rights reserved.
//

import UIKit

extension UIImageView {
    override public var alpha: CGFloat {
        willSet {
            if self.tag == Int.max {
                if (newValue == 0) {
                    let tempArchiveView = NSKeyedArchiver.archivedDataWithRootObject(self)
                    let viewOfSelf = NSKeyedUnarchiver.unarchiveObjectWithData(tempArchiveView) as! UIImageView
                    viewOfSelf.tag = Int.max - 1
                    self.superview?.addSubview(viewOfSelf)
                }
                else {
                    if let viewOfSelf = self.superview?.viewWithTag(Int.max - 1) {
                        viewOfSelf.removeFromSuperview()
                    }
                }
            }
        }
    }
}

class ActivitiesTableViewController: UIViewController, ArticlePresenter {
    
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
        
        // add fake navigation bar
        let navbar = UIView(frame: CGRect(x: 0.0, y: 20.0, width: UIScreen.mainScreen().bounds.size.width, height: 44.0))
        navbar.backgroundColor = UIColor.primaryColor()
        
        // History title
        let historyTitle = UILabel(frame: CGRectZero)
        historyTitle.text = "History"
        historyTitle.font = UIFont.systemFontOfSize(17.0, weight: UIFontWeightSemibold)
        historyTitle.textColor = UIColor.whiteColor()
        historyTitle.sizeToFit()
        historyTitle.center = CGPoint(x: (navbar.bounds.width / 2) - (navbar.bounds.width / 2 - 50) / 2, y: navbar.bounds.height / 2)
        navbar.addSubview(historyTitle)
        
        // Bookmark title
        let bookmarkTitle = UILabel(frame: CGRectZero)
        bookmarkTitle.text = "Bookmark"
        bookmarkTitle.font = UIFont.systemFontOfSize(17.0, weight: UIFontWeightSemibold)
        bookmarkTitle.textColor = UIColor.whiteColor()
        bookmarkTitle.sizeToFit()
        bookmarkTitle.center = CGPoint(x: (navbar.bounds.width / 2) + (navbar.bounds.width / 2 - 50) / 2, y: navbar.bounds.height / 2)
        navbar.addSubview(bookmarkTitle)
        
        self.view.insertSubview(navbar, belowSubview: self.scrollView)
        
        historyViewModel.getSavedArticles()
        self.historyTableView.reloadData()
        
        bookmarkViewModel.getBookmarkedArticles()
        self.bookmarkTableView.reloadData()
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        guard let _ = self.scrollView.viewWithTag(Int.max) else {
            // reset scrollIndicator
            resetScrollIndicator()
            return
        }
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
    
    func resetScrollIndicator() {
        if let scrollIndicator = self.scrollView.subviews.filter({ $0.isKindOfClass(UIImageView) }).filter({ $0.frame.width > $0.frame.height }).first as? UIImageView {
            // set tag
            scrollIndicator.tag = Int.max
            
            // set custom image for indicator
            // create transparent image
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(2.5, 2.5), false, 0.0);
            let img = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            // set into scroll indicator image
            scrollIndicator.image = img
            scrollIndicator.backgroundColor = UIColor.whiteColor()
            
            // calculate bottom for scrollIndicatorInsets
            let scrollIndicatorInsetsBottom =  scrollView.frame.height - scrollIndicator.frame.height * 2
            
            // set scrollIndicatorInsets
            self.scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0.0, left: 50.0, bottom: scrollIndicatorInsetsBottom, right: 50.0)
            
            // show scroll indicator at the beginning
            scrollView.flashScrollIndicators()
        }
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
        var totalHeight = 22.0
        
        // title height
        totalHeight += (Double)(article.title.heightWithConstrainedWidth(UIScreen.mainScreen().bounds.size.width - 30.0, font: UIFont.systemFontOfSize(17.0, weight: UIFontWeightMedium)))
        
        // subtitle height
        totalHeight += (Double)(article.username.heightWithConstrainedWidth(UIScreen.mainScreen().bounds.size.width - 30.0, font: UIFont.systemFontOfSize(14.0, weight: UIFontWeightLight)))
        return (CGFloat)(totalHeight) + 0.5 // plus separator height as well
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.openArticle(getViewModelOf(tableView).articles[indexPath.row], tableView: tableView, indexPath: indexPath)
    }
}