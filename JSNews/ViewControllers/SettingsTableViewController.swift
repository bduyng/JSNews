//
//  TableViewController.swift
//  JSNews
//
//  Created by Duy Bao Nguyen on 3/7/16.
//  Copyright © 2016 Duy Bao Nguyen. All rights reserved.
//

import UIKit
import SafariServices

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
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return (25.0 + 17.5)
        }
        return 25.0
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == 0) {
            cell.selectionStyle = .None
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).textLabel!.textColor = UIColor.primaryColor()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let headerTitleForSection = tableView.headerViewForSection(indexPath.section)!.textLabel!.text else {
            return
        }
        
        if (headerTitleForSection == SettingsConstants.TextSize.headerTitle) {
            didSelectRowInTextSizeSection(indexPath)
        }
        else if (headerTitleForSection == SettingsConstants.Author.headerTitle) {
            didSelectRowInAuthorSection(indexPath)
        }
    }
    
    // MARK: - UIControlEventValueChanged
    
    @IBAction func didChangeReaderMode(sender: UISwitch) {
        UserSettings.EnterReaderModeFirst = sender.on
    }
    
    // MARK: - Private methods
    
    func didSelectRowInTextSizeSection(indexPath: NSIndexPath) {
        // Do nothing if the selected cell already set
        guard let selectedCell = self.tableView.cellForRowAtIndexPath(indexPath) where selectedCell.accessoryType != .Checkmark else {
            return
        }
        
        // Remove checkmark from previous selected cell
        let numberOfRowsInSelectedSection = self.tableView.numberOfRowsInSection(indexPath.section)
        for i in 0...numberOfRowsInSelectedSection - 1 {
            if let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: indexPath.section)) where cell.accessoryType == .Checkmark {
                cell.accessoryType = .None
                break
            }
        }
        
        // Add checkmark for current selected cell
        selectedCell.accessoryType = .Checkmark
        
        // Save setting
        if let selectedTextSize = selectedCell.textLabel?.text {
            switch selectedTextSize {
            case SettingsConstants.TextSize.Small.key:
                UserSettings.TextSize = SettingsConstants.TextSize.Small.value
            case SettingsConstants.TextSize.Large.key:
                UserSettings.TextSize = SettingsConstants.TextSize.Large.value
            default:
                UserSettings.TextSize = SettingsConstants.TextSize.Medium.value
            }
        }
    }
    
    func didSelectRowInAuthorSection(indexPath: NSIndexPath) {
        let selectedCell = self.tableView.cellForRowAtIndexPath(indexPath)!
        
        // Open Email
        guard selectedCell.accessibilityIdentifier != SettingsConstants.Author.Email.accessibilityIdentifier else {
            let url = SettingsConstants.Author.Email.url
                .stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
            UIApplication.sharedApplication().openURL(NSURL(string:url)!)
            return
        }
        
        // Open Twitter or Github
        var urlStr: String?
        
        if selectedCell.accessibilityIdentifier == SettingsConstants.Author.Twitter.accessibilityIdentifier {
            urlStr = SettingsConstants.Author.Twitter.url
        }
        else if selectedCell.accessibilityIdentifier == SettingsConstants.Author.Github.accessibilityIdentifier {
            urlStr = SettingsConstants.Author.Github.url
        }
        
        // Make sure url is correct
        guard let url = NSURL(string: urlStr!) else {
            return
        }
        
        // Open the url by safari controller
        let safariVC = SFSafariViewController(URL: url,
            entersReaderIfAvailable: UserSettings.EnterReaderModeFirst
        )
        self.presentViewController(safariVC, animated: true, completion: nil)
    }
}