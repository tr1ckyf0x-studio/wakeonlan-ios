//
//  SelfSizingBottomSheetModalTransitionDelegate.swift
//  Wake on LAN
//
//  Created by Vladislav Lisianskii on 15.12.2020.
//  Copyright © 2020 Vladislav Lisianskii. All rights reserved.
//

import UIKit

public final class SelfSizingBottomSheetModalTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {

    public func animationController(
        forDismissed dismissed: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        SelfSizingBottomSheetModalAnimator()
    }

    public func presentationController(
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
