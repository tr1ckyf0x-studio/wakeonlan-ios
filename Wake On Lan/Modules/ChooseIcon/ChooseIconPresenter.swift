//
//  ChooseIconPresenter.swift
//  Wake on LAN
//
//  Created by Dmitry Stavitsky on 28.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

class ChooseIconPresenter {
    weak var view: ChooseIconViewInput!
    var router: ChooseIconRouterProtocol!

    private(set) lazy var tableManager: ChooseIconTableManager = {
        return ChooseIconTableManager(with: configureSections())
    }()

    private func configureSections() -> [ChooseIconSection] {
        let items: [ChooseIconSectionItem] = [
            R.image.other(),
            R.image.desktop(),
            R.image.router(),
            R.image.scanner(),
            R.image.tv()].map {
                let image = $0?.withRenderingMode(.alwaysTemplate)
                let model = IconModel(picture: image)
                let item = ChooseIconSectionItem.icon(model)
                return item
        }

        return [ChooseIconSection.section(content: items)]
    }

}

extension ChooseIconPresenter: ChooseIconViewOutput {

    func viewWillLayoutSubviews(_ view: ChooseIconViewInput) {
        view.reloadCollectionViewLayout()
    }

}
