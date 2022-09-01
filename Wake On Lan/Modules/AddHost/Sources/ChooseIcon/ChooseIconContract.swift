//
//  ChooseIconContract.swift
//  Wake on LAN
//
//  Created by Dmitry Stavitsky on 28.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import Foundation
import SharedProtocolsAndModels
import WOLUIComponents

// sourcery: AutoMockable
protocol ChooseIconViewInput: AnyObject {
    var presenter: ChooseIconViewOutput! { get set }

    func reloadCollectionViewLayout()

    func updateIconViewHeight()
}

protocol ChooseIconViewOutput {
    var tableManager: ChooseIconTableManager { get }

    func viewDidLoad(_ view: ChooseIconViewInput)

    func viewWillLayoutSubviews(_ view: ChooseIconViewInput)
}

// sourcery: AutoMockable
protocol ChooseIconRouterProtocol: AnyObject {
    func dismiss(animated: Bool)
}

// MARK: - Module delegate

// sourcery: AutoMockable
protocol ChooseIconModuleOutput: AnyObject {
    func chooseIconModuleDidSelectIcon(_ iconModel: IconModel)
}
