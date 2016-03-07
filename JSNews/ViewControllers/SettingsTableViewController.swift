//
//  TableViewController.swift
//  JSNews
//
//  Created by Duy Bao Nguyen on 3/7/16.
//  Copyright © 2016 Duy Bao Nguyen. All rights reserved.
//

import UIKit
import SafariServices

struct SettingsConstants {
    static let Twitter = 0
    static let Github = 1
    static let Email = 2
}

class SettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tintColor = UIColor.primaryColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == 0) {
            cell.selectionStyle = .None
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).textLabel!.textColor = UIColor.primaryColor()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == 0) {
            for cell in tableView.visibleCells {
                if cell.accessoryType == .Checkmark {
                    cell.accessoryType = .None
                }
            }
            
            let selectedCell = tableView.cellForRowAtIndexPath(indexPath)
            selectedCell?.accessoryType = .Checkmark
        }
        else if (indexPath.section == 1) {
            var url : String?
            switch indexPath.row {
                case SettingsConstants.Twitter:
                    url = "https://twitter.com/bduyng"
                case SettingsConstants.Github:
                    url = "https://github.com/bduyng"
                default:
                    url = nil
            }
            
            if (url != nil) {
                let safariVC = SFSafariViewController(URL: NSURL(string: url!)!, entersReaderIfAvailable: true)
                safariVC.view.tintColor = UIColor.primaryColor()
                self.presentViewController(safariVC, animated: true, completion: nil)
            }
        }
        
    }
}