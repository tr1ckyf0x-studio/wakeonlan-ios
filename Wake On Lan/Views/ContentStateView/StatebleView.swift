//
//  ContentStateView.swift
//  Wake on LAN
//
//  Created by Dmitry on 15.11.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit
import SnapKit

enum ViewState {
    case `default`
    case empty
    case error
    case waiting

}

protocol DisplaysStateView where Self: UIView {
    func configure(with viewModel: StateableViewModel)

}

// MARK: - StateableView

protocol StateableView: AnyObject {
    var currentState: ViewState? { get set }

    func showState(_ state: ViewState)
    func clearState()
    func view(for state: ViewState) -> DisplaysStateView?

}

extension StateableView where Self: UIView {

    var currentState: ViewState? {
        get {
            objc_getAssociatedObject(
                self,
                &Constants.associateKey
            ) as? ViewState
        }

        set {
            if newValue == currentState { return }
            objc_setAssociatedObject(
                self,
                &Constants.associateKey,
                newValue,
                .OBJC_ASSOCIATION_RETAIN
            )
        }
    }

    func view(for state: ViewState) -> DisplaysStateView? { nil }

    func clearState() {
        currentState = .default
        let stateView = viewWithTag(Constants.viewTag)
        stateView?.removeFromSuperview()
    }

    func showState(_ state: ViewState) {
        currentState = state
        clearState()
        guard let stateView = view(for: state) else { return }
        stateView.tag = Constants.viewTag
        addSubview(stateView)
        stateView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        bringSubviewToFront(stateView)
    }

}

// MARK: - Constants

private enum Constants {
    static let viewTag = UUID().hashValue
    static var associateKey: Void?

}
