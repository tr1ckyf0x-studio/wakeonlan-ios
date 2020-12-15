//
//  SelfSizingBottomSheetModalAnimator.swift
//  MOBAPP_B2C
//
//  Created by Владислав Лисянский on 30.11.2020.
//

import UIKit

class SelfSizingBottomSheetModalAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.33
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
