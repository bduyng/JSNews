//
//  WKWebViewController.swift
//  JSNews
//
//  Created by Duy Bao Nguyen on 2/23/16.
//  Copyright © 2016 Duy Bao Nguyen. All rights reserved.
//

import UIKit
import WebKit

class WKWebViewController: UIViewController {
    weak var delegate: WKWebViewControllerDelegate?
    var indexPath: NSIndexPath?
    var webView: WKWebView?
    var url: String?
    
    override func loadView() {
        super.loadView()
        self.webView = WKWebView()
        self.view = self.webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add toolbar
        let back = UIBarButtonItem(image: UIImage(named: "Back"), style: .Plain, target: self, action: "dismiss")
        let forward = UIBarButtonItem(image: UIImage(named: "Forward"), style: .Plain, target: self, action: nil)
        forward.enabled = false
        let bookmark = UIBarButtonItem(image: UIImage(named: "Bookmark"), style: .Plain, target: self, action: nil)
        bookmark.enabled = false
        let chrome = UIBarButtonItem(image: UIImage(named: "Chrome"), style: .Plain, target: self, action: "openInChrome")
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil)
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: self, action: nil)
        fixedSpace.width = 30.0
        
        self.toolbarItems = [back, fixedSpace, forward, flexibleSpace, bookmark, flexibleSpace, chrome]
        
        self.navigationController?.toolbarHidden = false
        self.navigationController?.toolbar.tintColor = UIColor.primaryColor()
        
        self.webView?.allowsBackForwardNavigationGestures = true
        
        // do not allow to overlap status bar
        let statusBarFrame = UIApplication.sharedApplication().statusBarFrame
        let statusBarBackground = UIView(frame: CGRect(x: 0, y: 0, width: statusBarFrame.size.width, height: statusBarFrame.size.height))
        statusBarBackground.backgroundColor = UIColor.darkPrimaryColor()
        self.view.addSubview(statusBarBackground)
        
        let req = NSURLRequest(URL: NSURL(string:self.url!)!)
        self.webView?.loadRequest(req)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.webView?.stopLoading()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismiss() {
        if self.webView?.canGoBack == false {
            self.dismissViewControllerAnimated(true, completion: {
                self.delegate?.didDismissWebView(self.indexPath!)
            })
        }
        else {
            self.webView?.goBack()
        }
    }
    
    func openInChrome() {
        // check
        if UIApplication.sharedApplication().canOpenURL(NSURL(string: "googlechrome://")!) == false {
            UIApplication.sharedApplication().openURL(NSURL(string: "itms-apps://itunes.apple.com/us/app/chrome/id535886823")!)
        }
        else {
            // Replace the URL Scheme with the Chrome equivalent.
            var chromeScheme: String?;
            if self.url!.lowercaseString.rangeOfString("http") != nil {
                chromeScheme = "googlechrome"
            }
            else if self.url!.lowercaseString.rangeOfString("https") != nil {
                chromeScheme = "googlechromes"
            }
            
            // Proceed only if a valid Google Chrome URI Scheme is available.
            if chromeScheme != nil {
                let rangeForScheme = self.url!.rangeOfString(":")
                let urlNoScheme = self.url?.substringFromIndex((rangeForScheme?.startIndex)!)
                let chromeURLString = chromeScheme?.stringByAppendingString(urlNoScheme!)
                let chromeURL = NSURL(string: chromeURLString!)
                // Open the URL with Chrome.
                UIApplication.sharedApplication().openURL(chromeURL!)
            }
        }
    }
}

protocol WKWebViewControllerDelegate: class {
    func didDismissWebView(indexPath: NSIndexPath)
}
