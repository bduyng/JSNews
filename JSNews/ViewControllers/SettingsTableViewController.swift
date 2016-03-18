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
    
    // MARK: Properties
    @IBOutlet var switcher: UISwitch!
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tintColor = UIColor.primaryColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // set last text size
        var lastTextSizeKey: String?
        switch UserSettings.TextSize {
        case SettingsConstants.TextSize.Small.value:
            lastTextSizeKey = SettingsConstants.TextSize.Small.key
        case SettingsConstants.TextSize.Large.value:
            lastTextSizeKey = SettingsConstants.TextSize.Large.key
        default:
            lastTextSizeKey = SettingsConstants.TextSize.Medium.key
        }
        let numberOfRowsInSelectedSection = self.tableView.numberOfRowsInSection(0)
        for i in 0..<numberOfRowsInSelectedSection {
            if let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: 0)) {
                if cell.textLabel?.text == lastTextSizeKey {
                    cell.accessoryType = .Checkmark
                }
                else {
                    cell.accessoryType = .None
                }
            }
            
        }
        
        
        // set last switcher
        switcher.on = UserSettings.EnterReaderModeFirst
        
        // only scrollable when there are invisible cells
        // assume that version cell is always the last cell
        self.tableView.scrollEnabled = self.tableView.visibleCells.last?.textLabel?.text != "1.0.0"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25.0 + (section == 0 ? 17.5 : 0)
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).textLabel!.textColor = UIColor.primaryColor()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let headerTitleForSection = tableView.headerViewForSection(indexPath.section)!.textLabel!.text else { return }
        
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
    
    // MARK: Convenience
    func didSelectRowInTextSizeSection(indexPath: NSIndexPath) {
        // Do nothing if the selected cell already set
        guard let selectedCell = self.tableView.cellForRowAtIndexPath(indexPath) where selectedCell.accessoryType != .Checkmark else {
            return
        }
        
        // Remove checkmark from previous selected cell
        let numberOfRowsInSelectedSection = self.tableView.numberOfRowsInSection(indexPath.section)
        for i in 0..<numberOfRowsInSelectedSection {
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
            UIApplication.sharedApplication().openURL(NSURL(string:SettingsConstants.Author.Email.url)!)
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
        
        // Open the url by safari controller
        let safariVC = SFSafariViewController(url: urlStr!)
        self.presentViewController(safariVC, animated: true, completion: nil)
    }
}