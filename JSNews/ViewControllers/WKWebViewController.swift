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

    @IBOutlet var containerView: UIView!
    var webView: WKWebView?
    var url: String?
    
    override func loadView() {
        super.loadView()
        self.webView = WKWebView()
        self.view = self.webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = true
        
        self.webView?.navigationDelegate = self
        
        self.webView?.scrollView.delegate = self
        
        print(self.view.frame.size.width)
        
        // add title
        let label = UILabel()
        
        label.frame.origin = CGPoint(x: UIApplication.sharedApplication().statusBarFrame.size.width / 2 , y: 30)
        label.text = "Demo"
        label.tag = 101
        label.alpha = 0.0
        label.sizeToFit()
        self.view.addSubview(label)
        
        // do not allow to overlap status bar
        let statusBarFrame = UIApplication.sharedApplication().statusBarFrame
        let statusBarBackground = UIView(frame: CGRect(x: 0, y: 0, width: statusBarFrame.size.width, height: statusBarFrame.size.height))
        statusBarBackground.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(statusBarBackground)
        
        
        // add toolbar
        let add = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: nil)
        let spacer = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil)
        self.toolbarItems = [add, spacer]
        
        self.navigationController?.toolbarHidden = false
        
        // FIXME: Not working
        self.webView?.allowsBackForwardNavigationGestures = true
        
        // do not allow the web view overlap title in navigation bar
        //self.webView?.backgroundColor = UIColor.whiteColor()
        
        
        
        let req = NSURLRequest(URL: NSURL(string:self.url!)!)
        self.webView!.loadRequest(req)
        
    }
    
    func close() {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension WKWebViewController: WKNavigationDelegate {
    func webView(webView: WKWebView, didCommitNavigation navigation: WKNavigation!) {
//        webView.scrollView.frame.origin.y = 20
        webView.scrollView.subviews.first!.frame.origin.y = 44
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        webView.scrollView.backgroundColor = UIColor.whiteColor()
    }
}

extension WKWebViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // animate indicator
        let indicator = self.view.viewWithTag(101)!
        let curY = scrollView.contentOffset.y
        print(curY)
        if curY == -20 {
            indicator.alpha = 0;
        }
        else if curY == -120 {
            indicator.alpha = 1;
        }
        else {
            indicator.alpha = (-20 - curY) / 100
        }
        
    }
}
