//
//  ContentStateView.swift
//  Wake on LAN
//
//  Created by Dmitry on 15.11.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import SharedProtocolsAndModels
import UIKit

// MARK: - StateableView

public protocol StateableView: AnyObject {
    var currentState: ViewState? { get set }

    func showState(_ state: ViewState)
    func clearState()
    func view(for state: ViewState) -> DisplaysStateView?
}

extension StateableView where Self: UIView {

    public var currentState: ViewState? {
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

    public func view(for state: ViewState) -> DisplaysStateView? { nil }

    public func clearState() {
        currentState = .default
        let stateView = viewWithTag(Constants.viewTag)
        stateView?.removeFromSuperview()
    }

    public func showState(_ state: ViewState) {
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

// MARK: - ViewState

public enum ViewState {
    case `default`
    case empty
    case error
    case waiting
}

// MARK: - DisplaysStateView

public protocol DisplaysStateView where Self: UIView {
    func configure(with viewModel: StateableViewModel)
}

// MARK: - Constants

private enum Constants {
    static let viewTag = UUID().hashValue
    static var associateKey: Void?
}
