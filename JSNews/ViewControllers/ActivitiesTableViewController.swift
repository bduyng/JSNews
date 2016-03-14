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
    static let clonedHighlighterTag = Int.max - 1
    static let historyTitle = "History"
    static let bookmarkTitle = "Bookmark"
}

extension UIImageView {
    override public var alpha: CGFloat {
        willSet {
            if self.tag == ActivitiesConstants.highlighterTag {
                if (newValue == 0) {
                    let tempArchiveView = NSKeyedArchiver.archivedDataWithRootObject(self)
                    let viewOfSelf = NSKeyedUnarchiver.unarchiveObjectWithData(tempArchiveView) as! UIImageView
                    viewOfSelf.tag = ActivitiesConstants.clonedHighlighterTag
                    self.superview?.addSubview(viewOfSelf)
                }
                else {
                    if let viewOfSelf = self.superview?.viewWithTag(ActivitiesConstants.clonedHighlighterTag) {
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
        
        addCustomNavbar()
        
        historyViewModel.getVisitedArticles()
        self.historyTableView.reloadData()
        
        bookmarkViewModel.getBookmarkedArticles()
        self.bookmarkTableView.reloadData()
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if self.scrollView.viewWithTag(ActivitiesConstants.highlighterTag) != nil {
            self.resetScrollIndicator()
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
            scrollIndicator.tag = ActivitiesConstants.highlighterTag
            
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
    
    func addCustomNavbar() {
        // Mimic navigation bar
        let navbar = UIView(frame: CGRect(x: 0.0, y: 20.0, width: UIScreen.mainScreen().bounds.size.width, height: 44.0))
        navbar.backgroundColor = UIColor.primaryColor()
        
        // History title
        let historyTitle = UIButton(frame: CGRectZero)
        historyTitle.titleLabel!.text = ActivitiesConstants.historyTitle
        historyTitle.titleLabel!.font = UIFont.systemFontOfSize(17.0, weight: UIFontWeightSemibold)
        historyTitle.titleLabel!.textColor = UIColor.whiteColor()
        historyTitle.sizeToFit()
        historyTitle.center = CGPoint(x: (navbar.bounds.width / 2) - (navbar.bounds.width / 2 - 50) / 2, y: navbar.bounds.height / 2)
        navbar.addSubview(historyTitle)
        
        // Bookmark title
        let bookmarkTitle = UIButton(frame: CGRectZero)
        bookmarkTitle.titleLabel!.text = ActivitiesConstants.bookmarkTitle
        bookmarkTitle.titleLabel!.font = UIFont.systemFontOfSize(17.0, weight: UIFontWeightSemibold)
        bookmarkTitle.titleLabel!.textColor = UIColor.whiteColor()
        bookmarkTitle.sizeToFit()
        bookmarkTitle.center = CGPoint(x: (navbar.bounds.width / 2) + (navbar.bounds.width / 2 - 50) / 2, y: navbar.bounds.height / 2)
        navbar.addSubview(bookmarkTitle)
        
        self.view.insertSubview(navbar, belowSubview: self.scrollView)
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