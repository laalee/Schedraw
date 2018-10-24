//
//  FlipPresentAnimationController.swift
//  Schedule
//
//  Created by HsinYuLi on 2018/10/24.
//  Copyright © 2018年 laalee. All rights reserved.
//

import Foundation
import UIKit

class FadePushAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {

        return 0.2
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        guard let toViewController = transitionContext.viewController(forKey: .to) else {
                return
        }

        transitionContext.containerView.addSubview(toViewController.view)

        toViewController.view.alpha = 0

        let duration = self.transitionDuration(using: transitionContext)

        UIView.animate(withDuration: duration, animations: {

            toViewController.view.alpha = 1

        }, completion: { _ in

            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }

}
