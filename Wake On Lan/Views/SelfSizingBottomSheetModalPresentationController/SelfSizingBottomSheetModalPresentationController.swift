//
//  SelfSizingBottomSheetModalPresentationController.swift
//  Wake on LAN
//
//  Created by Владислав Лисянский on 15.12.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit

class SelfSizingBottomSheetModalPresentationController: UIPresentationController {

    private var _dimmingView: UIView?

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()

    private var bottomcontentViewConstraint: NSLayoutConstraint?

    private var tapGestureRecognizer: UITapGestureRecognizer

    private var dimmingView: UIView {
        if let dimmedView = _dimmingView {
            return dimmedView
        }
        guard let containerView = containerView else { return UIView() }
        let view = UIView(frame: CGRect(x: 0,
                                        y: 0,
                                        width: containerView.bounds.width,
                                        height: containerView.bounds.height))

        // Blur Effect
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)

        // Vibrancy Effect
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyEffectView.frame = view.bounds

        // Add the vibrancy view to the blur view
        blurEffectView.contentView.addSubview(vibrancyEffectView)

        _dimmingView = view

        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(recognizer:)))
        tapGestureRecognizer.cancelsTouchesInView = false
        _dimmingView?.addGestureRecognizer(tapGestureRecognizer)

        return view
    }

//    private var startYPosition: CGFloat {
//        guard let view = presentedView, let superview = view.superview else { return 0 }
//        let startPoint = superview.frame.maxY - view.bounds.height
//        let y = startPoint < safeAreaInsetsTop ? safeAreaInsetsTop : startPoint
//        return y
//    }
//
//    private var safeAreaInsetsTop: CGFloat {
//        let safeAreaInsetsTop = UIApplication.shared.keyWindow!.safeAreaInsets.top
//        return safeAreaInsetsTop == 0 ? 20 : safeAreaInsetsTop
//    }

    override var presentedView: UIView? {
        contentView
    }

    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        self.tapGestureRecognizer = UITapGestureRecognizer()
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }

    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        installPresentedViewInCustomViews()
    }

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()

        installCustomViews()
        installPresentedViewInCustomViews()
        animateDimmingViewIn()
    }

    override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
        if !completed {
            removeCustomViews()
        }
    }

    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        animateDimmingViewOut()
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)
        guard completed else { return }
        removeCustomViews()
    }
}

// MARK: - Private methods
extension SelfSizingBottomSheetModalPresentationController {
    private func installCustomViews() {
        guard let containerView = containerView else {
            assertionFailure("Can't set up custom views without a container view. Transition must not be started yet.")
            return
        }

        containerView.addSubview(dimmingView)
        containerView.addSubview(contentView)

        let bottomcontentViewConstraint = contentView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        self.bottomcontentViewConstraint = bottomcontentViewConstraint

        NSLayoutConstraint.activate([
            dimmingView.topAnchor.constraint(equalTo: containerView.topAnchor),
            dimmingView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            containerView.bottomAnchor.constraint(equalTo: dimmingView.bottomAnchor),
            containerView.trailingAnchor.constraint(equalTo: dimmingView.trailingAnchor),

            // Fit the card to the bottom of the screen within the readable width.
            contentView.topAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: containerView.readableContentGuide.topAnchor, multiplier: 1),
            contentView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            bottomcontentViewConstraint,
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor), {
                // Weakly squeeze the content toward the bottom. This functions
                // just like the `verticalFittingPriority` in
                // `UIView.systemLayoutSizeFitting` to get the card to try
                // and fit its content while meeting the other constrainnts.
                let minimizingHeight = contentView.heightAnchor.constraint(equalToConstant: 0)
                minimizingHeight.priority = .fittingSizeLevel
                return minimizingHeight
            }()
        ])
    }

    private func installPresentedViewInCustomViews() {
        guard !presentedViewController.view.isDescendant(of: contentView) else { return }

        presentedViewController.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(presentedViewController.view)

        NSLayoutConstraint.activate([
            presentedViewController.view.topAnchor.constraint(equalTo: contentView.topAnchor),
            presentedViewController.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: presentedViewController.view.bottomAnchor),
            contentView.trailingAnchor.constraint(equalTo: presentedViewController.view.trailingAnchor)
        ])
    }

    private func removeCustomViews() {
        contentView.removeFromSuperview()
        dimmingView.removeFromSuperview()
    }

    private func animateDimmingViewIn() {
        dimmingView.alpha = 0
        presentingViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1
        }, completion: nil)
    }

    private func animateDimmingViewOut() {
        presentingViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0
        }, completion: nil)
    }

    @objc private func handleTap(recognizer: UITapGestureRecognizer) {
        presentedViewController.dismiss(animated: true)
    }
}
