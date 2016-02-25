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
        let bookmark = UIBarButtonItem(barButtonSystemItem: .Bookmarks, target: self, action: "close")
        let spacer = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil)
        self.toolbarItems = [bookmark, spacer]
        
        self.navigationController?.toolbarHidden = false
        
        self.webView?.allowsBackForwardNavigationGestures = true
        
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
    
    func close() {
        self.dismissViewControllerAnimated(true, completion: {
            self.delegate?.didDismissWebView(self.indexPath!)
        })
    }
}

protocol WKWebViewControllerDelegate: class {
    func didDismissWebView(indexPath: NSIndexPath)
}
