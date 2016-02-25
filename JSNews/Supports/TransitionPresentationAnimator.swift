//
//  TransitionPresentationAnimator.swift
//  JSNews
//
//  Created by Duy Bao Nguyen on 2/24/16.
//  Copyright © 2016 Duy Bao Nguyen. All rights reserved.
//

import UIKit

class TransitionPresentationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let finalFrameForVC = transitionContext.finalFrameForViewController(toViewController)
        let containerView = transitionContext.containerView()
        
        toViewController.view.frame = CGRectOffset(finalFrameForVC, UIScreen.mainScreen().bounds.size.width, 0)
        containerView!.addSubview(toViewController.view)
        
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
            fromViewController.view.alpha = 0.5
            fromViewController.view.frame = CGRectOffset(finalFrameForVC, -100.0, 0)
            toViewController.view.frame = finalFrameForVC
            }, completion: {
                finished in
                transitionContext.completeTransition(true)
        })
    }
}
