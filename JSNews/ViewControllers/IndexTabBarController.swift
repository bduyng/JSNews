//
//  IndexTabBarController.swift
//  JSNews
//
//  Created by Duy Bao Nguyen on 1/17/16.
//  Copyright © 2016 Duy Bao Nguyen. All rights reserved.
//

import UIKit

class IndexTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set tintColor
        self.tabBar.tintColor = UIColor.primaryColor()
        
        // select middle tab as default
        self.selectedIndex = 1

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if self.selectedIndex == 1 && tabBar.items![self.selectedIndex] == item {
            item.title = item.title == "Top" ? "Latest" : "Top"
            item.image = item.image == UIImage(named: "Top") ? UIImage(named: "Latest") : UIImage(named: "Top")
            item.selectedImage = item.image == UIImage(named: "Latest") ? UIImage(named: "LatestSelected") : UIImage(named: "TopSelected")
        }
    }

}
