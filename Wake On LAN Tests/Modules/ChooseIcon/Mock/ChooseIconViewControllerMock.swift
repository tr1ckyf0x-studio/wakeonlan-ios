//
//  ChooseIconViewControllerMock.swift
//  WakeOnLanTests
//
//  Created by Владислав Лисянский on 01.11.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit
@testable import Wake_on_LAN

class ChooseIconViewControllerMock: UIViewController {
    var presenter: ChooseIconViewOutput!

    private(set) var didCallMakePresentingViewControllerDimmed = false
    private(set) var didCallMakePresentingViewControllerTransparent = false
    private(set) var didCallReloadCollectionViewLayout = false
    private(set) var didCallUpdateIconViewHeight = false
    private(set) var didCallDismiss = false
}

extension ChooseIconViewControllerMock: ChooseIconViewInput {
    func makePresentingViewControllerDimmed() {
        didCallMakePresentingViewControllerDimmed = true
    }

    func makePresentingViewControllerTransparent() {
        didCallMakePresentingViewControllerTransparent = true
    }

    func reloadCollectionViewLayout() {
        didCallReloadCollectionViewLayout = true
    }

    func updateIconViewHeight() {
        didCallUpdateIconViewHeight = true
    }
}

extension ChooseIconViewControllerMock {
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        didCallDismiss = true
        super.dismiss(animated: flag, completion: completion)
    }
}
