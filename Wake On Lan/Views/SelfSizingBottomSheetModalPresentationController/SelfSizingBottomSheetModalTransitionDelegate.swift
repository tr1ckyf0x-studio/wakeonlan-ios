//
//  SelfSizingBottomSheetModalTransitionDelegate.swift
//  Wake on LAN
//
//  Created by Владислав Лисянский on 15.12.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit

class SelfSizingBottomSheetModalTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {

    func animationController(
        forDismissed dismissed: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        SelfSizingBottomSheetModalAnimator()
    }

    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        SelfSizingBottomSheetModalPresentationController(
            presentedViewController: presented,
            presenting: presenting
        )
    }
}
