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

    private let sections: [ChooseIconSection] = {
        let items: [FormItem] = [R.image.other, R.image.desktop, R.image.router, R.image.scanner, R.image.tv].map {
            let model = IconModel(pictureName: $0.name)
            return .icon(model)
        }

        return [ChooseIconSection.section(content: items)]
    }()

    private(set) lazy var tableManager: ChooseIconTableManager = {
        return .init(with: sections)
    }()

}

// MARK: - ChooseIconViewOutput
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

// MARK: - ChooseIconTableManagerDelegate
extension ChooseIconPresenter: ChooseIconTableManagerDelegate {
    func tableManager(_ manager: ChooseIconTableManager, didTapIcon icon: IconModel) {
        moduleDelegate?.chooseIconModuleDidSelectIcon(icon)
        view.dismiss(animated: true)
    }

}
