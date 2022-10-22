//
//  ChooseIconPresenter.swift
//  Wake on LAN
//
//  Created by Dmitry Stavitsky on 28.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import SharedProtocolsAndModels
import SharedRouter
import WOLResources
import WOLUIComponents

final class ChooseIconPresenter: Navigates {
    weak var view: ChooseIconViewInput!
    weak var moduleDelegate: ChooseIconModuleOutput?
    var router: ChooseIconRoutes!

    private(set) lazy var tableManager = ChooseIconTableManager(with: sections)

    private let sections: [ChooseIconSection] =
        [
            HostIcon.allCases
                .map { IconModel(sfSymbol: $0) }
                .map { .icon($0) }
        ]
        .map { .section(content: $0) }

}

// MARK: - ChooseIconViewOutput

extension ChooseIconPresenter: ChooseIconViewOutput {

    func viewDidLoad(_ view: ChooseIconViewInput) {
        tableManager.delegate = self
    }

    func viewWillLayoutSubviews(_ view: ChooseIconViewInput) {
        view.reloadCollectionViewLayout()
        view.updateIconViewHeight()
    }

}

// MARK: - ChooseIconTableManagerDelegate

extension ChooseIconPresenter: ChooseIconTableManagerDelegate {
    func tableManager(_ manager: ChooseIconTableManager, didTapIcon icon: IconModel) {
        moduleDelegate?.chooseIconModuleDidSelectIcon(icon)
        navigate(to: router.backOrDismiss(animated: true)) 
    }
}
