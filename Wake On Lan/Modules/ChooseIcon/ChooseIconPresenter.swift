//
//  ChooseIconPresenter.swift
//  Wake on LAN
//
//  Created by Dmitry Stavitsky on 28.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

class ChooseIconPresenter {
    weak var view: ChooseIconViewInput!
    weak var moduleDelegate: ChooseIconModuleOutput?
    var router: ChooseIconRouterProtocol!

    var items: [FormItem]!

    private(set) lazy var tableManager: ChooseIconTableManager = {
        return ChooseIconTableManager(with: createSections())
    }()

    private func createSections() -> [ChooseIconSection] {
        return [ChooseIconSection.section(content: items)]
    }

}

extension ChooseIconPresenter: ChooseIconViewOutput {
    func viewDidLoad(_ view: ChooseIconViewInput) {
        view.makePresentingViewControllerDimmed()
        tableManager.delegate = self
    }

    func viewWillDisappear(_ view: ChooseIconViewInput) {
        view.makePresentingViewControllerTransparent()
    }

    func viewWillLayoutSubviews(_ view: ChooseIconViewInput) {
        view.reloadCollectionViewLayout()
        view.updateIconViewHeight()
    }

}

extension ChooseIconPresenter: ChooseIconTableManagerDelegate {
    func tableManager(_ manager: ChooseIconTableManager, didTapIcon icon: IconModel) {
        moduleDelegate?.chooseIconModuleDidSelectIcon(icon)
        view.dismiss(animated: true)
    }

}
