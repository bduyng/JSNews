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
        
        self.webView?.allowsBackForwardNavigationGestures = true
        
        let label = UILabel()
        label.frame.origin = CGPoint(x: 10, y: 10)
        label.text = "Demo"
        label.sizeToFit()
        self.view.addSubview(label)
        
        print(self.webView?.superview)
        
        self.webView?.backgroundColor = UIColor.whiteColor()
        
        self.webView?.scrollView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        
        let req = NSURLRequest(URL: NSURL(string:self.url!)!)
        self.webView!.loadRequest(req)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



}

extension WKWebViewController: WKNavigationDelegate {
    func webView(webView: WKWebView, didCommitNavigation navigation: WKNavigation!) {
        print("C")
        let contentView = self.webView?.scrollView.subviews.first
        contentView!.frame.origin.y = 44
    }
    
}

extension WKWebViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
    }
}
