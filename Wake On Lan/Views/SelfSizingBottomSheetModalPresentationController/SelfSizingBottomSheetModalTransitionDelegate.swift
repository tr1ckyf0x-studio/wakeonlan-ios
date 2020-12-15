//
//  SelfSizingBottomSheetModalTransitionDelegate.swift
//  MOBAPP_B2C
//
//  Created by Владислав Лисянский on 30.11.2020.
//

import UIKit

class SelfSizingBottomSheetModalTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SelfSizingBottomSheetModalAnimator()
    }

    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        SelfSizingBottomSheetModalPresentationController(presentedViewController: presented,
                                                         presenting: presenting)
    }
}
