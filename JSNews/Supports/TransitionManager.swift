//
//  TransitionManager.swift
//  JSNews
//
//  Created by Duy Bao Nguyen on 2/25/16.
//  Copyright © 2016 Duy Bao Nguyen. All rights reserved.
//

import UIKit

struct TransitionType {
    static let Present = 0
    static let Dismiss = 1
}

class TransitionManager: UIPercentDrivenInteractiveTransition {
    var type = TransitionType.Present
}

extension TransitionManager: UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        if self.type == TransitionType.Present { present(transitionContext) }
        if self.type == TransitionType.Dismiss { dismiss(transitionContext) }
    }
    
    func present(transitionContext: UIViewControllerContextTransitioning) {
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
    
    func dismiss(transitionContext: UIViewControllerContextTransitioning) {
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

extension TransitionManager: UIViewControllerTransitioningDelegate {
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.type = TransitionType.Present
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.type = TransitionType.Dismiss
        return self
    }
}
