//
//  SelfSizingBottomSheetModalAnimator.swift
//  Wake on LAN
//
//  Created by Владислав Лисянский on 15.12.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit

class SelfSizingBottomSheetModalAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    private enum Configuration {
        static let transitionDuration = 0.33
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        Configuration.transitionDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let from = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)

        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       animations: { () -> Void in
                        from?.view.frame.origin.y = UIScreen.main.bounds.size.height
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
