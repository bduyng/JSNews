//
//  IndexTabBarController.swift
//  JSNews
//
//  Created by Duy Bao Nguyen on 1/17/16.
//  Copyright © 2016 Duy Bao Nguyen. All rights reserved.
//

import UIKit

class IndexTabBarController: UITabBarController {

    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set tintColor
        self.tabBar.tintColor = UIColor.primaryColor()
        
        // FIXME: Set middle tab as default
        self.selectedIndex = 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}