//
//  ChooseIconContract.swift
//  Wake on LAN
//
//  Created by Dmitry Stavitsky on 28.05.2020.
//  Copyright © 2020 Vladislav Lisianskii. All rights reserved.
//

import SharedProtocolsAndModels
import WOLUIComponents

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

// MARK: - Module delegate

public protocol ChooseIconModuleOutput: AnyObject {
    func chooseIconModuleDidSelectIcon(_ iconModel: IconModel)
}
