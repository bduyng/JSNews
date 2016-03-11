//
//  IndexTabBarController.swift
//  JSNews
//
//  Created by Duy Bao Nguyen on 1/17/16.
//  Copyright © 2016 Duy Bao Nguyen. All rights reserved.
//

import UIKit

class IndexTabBarController: UITabBarController {

    // MARK: - View Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set tintColor
        self.tabBar.tintColor = UIColor.primaryColor()
        
        // FIXME: Set middle tab as default
        self.selectedIndex = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITabBarDelegate
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if self.selectedIndex == 1 && tabBar.items![self.selectedIndex] == item {
            item.image = item.image == UIImage(named: "Top") ? UIImage(named: "Latest") : UIImage(named: "Top")
            item.selectedImage = item.image == UIImage(named: "Latest") ? UIImage(named: "LatestSelected") : UIImage(named: "TopSelected")
        }
    }

}