//
//  TransitionDismissalAnimator.swift
//  JSNews
//
//  Created by Duy Bao Nguyen on 2/24/16.
//  Copyright © 2016 Duy Bao Nguyen. All rights reserved.
//

import UIKit

class TransitionDismissalAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let finalFrameForVC = transitionContext.finalFrameForViewController(toViewController)
        
        fromViewController.view.frame = finalFrameForVC
        
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
            fromViewController.view.frame = CGRectOffset(finalFrameForVC, UIScreen.mainScreen().bounds.size.width, 0)
            toViewController.view.alpha = 1.0
            toViewController.view.frame = finalFrameForVC
            }, completion: {
                finished in
                transitionContext.completeTransition(true)
        })
    }
}
