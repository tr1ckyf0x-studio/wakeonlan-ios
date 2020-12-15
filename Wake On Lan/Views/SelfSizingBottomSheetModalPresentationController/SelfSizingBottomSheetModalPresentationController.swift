//
//  SelfSizingBottomSheetModalPresentationController.swift
//  Wake on LAN
//
//  Created by Владислав Лисянский on 15.12.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit

class SelfSizingBottomSheetModalPresentationController: UIPresentationController {

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()

    private lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(recognizer:)))
        gestureRecognizer.cancelsTouchesInView = false
        return gestureRecognizer
    }()

    private lazy var dimmingView: UIView = {
        let view = UIView()
        view.addGestureRecognizer(tapGestureRecognizer)
        return view
    }()

    private lazy var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark) // TODO: вынести в Appearance
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        return blurEffectView
    }()

    private lazy var vibrancyEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        return vibrancyEffectView
    }()

    override var presentedView: UIView? {
        contentView
    }

    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        addPresentedViewInCustomViews()
    }

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()

        addCustomViews()
        addPresentedViewInCustomViews()
        animateDimmingViewIn()
    }

    override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
        if completed { return }
        removeCustomViews()
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
    private func addCustomViews() {
        guard let containerView = containerView else {
            assertionFailure("Can't set up custom views without a container view. Transition must not be started yet.")
            return
        }

        containerView.addSubview(dimmingView)
        containerView.addSubview(contentView)
        dimmingView.addSubview(blurEffectView)
        blurEffectView.contentView.addSubview(vibrancyEffectView)

        dimmingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        blurEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        vibrancyEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
        }

        NSLayoutConstraint.activate([
            // Fit the card to the bottom of the screen within the readable width.
            contentView.topAnchor.constraint(
                greaterThanOrEqualToSystemSpacingBelow: containerView.readableContentGuide.topAnchor,
                multiplier: 1
            ),
            {
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

    private func addPresentedViewInCustomViews() {
        if presentedViewController.view.isDescendant(of: contentView) { return }

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
