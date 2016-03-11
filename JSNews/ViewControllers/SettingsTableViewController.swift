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
    struct Author {
        static let Twitter = 0
        static let Github = 1
        static let Email = 2
    }
    
    struct TextSize {
        static let Small = 15.0
        static let Medium = 17.0
        static let Large = 19.0
    }
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
            print(selectedCell?.textLabel?.text)
            
            // save setting
            let defaults = NSUserDefaults.standardUserDefaults()
            if let selectedTextSize = selectedCell?.textLabel?.text {
                switch selectedTextSize {
                case "Small":
                    defaults.setDouble(SettingsConstants.TextSize.Small, forKey: "TextSize")
                case "Large":
                    defaults.setDouble(SettingsConstants.TextSize.Large, forKey: "TextSize")
                default:
                    defaults.setDouble(SettingsConstants.TextSize.Medium, forKey: "TextSize")
                }
            }
        }
        else if (indexPath.section == 1) {
            var urlStr : String?
            switch indexPath.row {
            case SettingsConstants.Author.Twitter: urlStr = "https://twitter.com/bduyng"
            case SettingsConstants.Author.Github: urlStr = "https://github.com/bduyng"
            case SettingsConstants.Author.Email:
                let toEmail = "bduyng@gmail.com"
                let subject = "Feedback from JSNews"
                
                urlStr = ("mailto:\(toEmail)?subject=\(subject)")
                    .stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
                let url = NSURL(string:urlStr!)
                UIApplication.sharedApplication().openURL(url!)
                urlStr = nil
            default:
                urlStr = nil
            }
            
            guard urlStr != nil else {
                return
            }
            
            let defaults = NSUserDefaults.standardUserDefaults()
            let safariVC = SFSafariViewController(URL: NSURL(string: urlStr!)!, entersReaderIfAvailable: defaults.boolForKey("EnterReaderModeFirst"))
            safariVC.view.tintColor = UIColor.primaryColor()
            self.presentViewController(safariVC, animated: true, completion: nil)
        }
        
    }
}