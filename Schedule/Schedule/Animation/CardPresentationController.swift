//
//  CardPresentationController.swift
//  Schedule
//
//  Created by HsinYuLi on 2018/10/24.
//  Copyright © 2018 laalee. All rights reserved.
//

import UIKit

final class CardPresentationController: UIPresentationController {

    private lazy var blurView = UIVisualEffectView(effect: nil)

    // Default is false.
    // And also means you can access only `.to` when present, and `.from` when dismiss (e.g., can touch only 'presented view').
    //
    // If true, the presenting view is removed and you have to add it during animation accessing `.from` key.
    // And you will have access to both `.to` and `.from` view. (In the typical .fullScreen mode)
    override var shouldRemovePresentersView: Bool {
        return false
    }

    override func presentationTransitionWillBegin() {
        let container = containerView!
        blurView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(blurView)
        blurView.edges(to: container)
        blurView.alpha = 0.0

        presentingViewController.beginAppearanceTransition(false, animated: false)
        presentedViewController.transitionCoordinator!.animate(alongsideTransition: { (context) in
            UIView.animate(withDuration: 0.5, animations: {
                self.blurView.effect = UIBlurEffect(style: .light)
                self.blurView.alpha = 1
            })
        }) { (context) in }
    }

    override func presentationTransitionDidEnd(_ completed: Bool) {
        presentingViewController.endAppearanceTransition()
    }

    override func dismissalTransitionWillBegin() {
        presentingViewController.beginAppearanceTransition(true, animated: true)
        presentedViewController.transitionCoordinator!.animate(alongsideTransition: { (context) in
            self.blurView.alpha = 0.0
        }, completion: nil)
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        presentingViewController.endAppearanceTransition()
        if completed {
            blurView.removeFromSuperview()
        }
    }
}
