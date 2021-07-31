//
//  AboutScreenPresenter.swift
//  AboutScreen
//
//  Created by Vladislav Lisianskii on 24.04.2021.
//  Copyright © 2021 Владислав Лисянский. All rights reserved.
//

import Foundation
import SharedProtocols
import WOLResources

final class AboutScreenPresenter {

    weak var view: AboutScreenViewInput?

    var router: AboutScreenRouter?

    var interactor: AboutScreenInteractorInput?

    var tableManager: AboutScreenTableManager?

}

// MARK: - AboutScreenViewOutput

extension AboutScreenPresenter: AboutScreenViewOutput {

    func viewDidLoad(_ view: AboutScreenViewInput) {
        interactor?.fetchBundleInfo()
    }

    func viewDidPressBackButton(_ view: AboutScreenViewInput) {
        router?.popCurrentController(animated: true)
    }

}

// MARK: - AboutScreenInteractorOutput

extension AboutScreenPresenter: AboutScreenInteractorOutput {

    func interactor(_: AboutScreenInteractorInput, didFetchBundleInfo bundleInfo: BundleInfo) {
        tableManager?.sections = makeSections(from: bundleInfo)
    }

}

// MARK: - Private methods

private extension AboutScreenPresenter {

    func makeSections(from bundleInfo: BundleInfo) -> [AboutScreenSectionModel] {
        [
            .mainSection(
                content:
                    [
                        .header(appName: bundleInfo.displayName, appVersion: bundleInfo.version),
                        .menuButton(title: "Test", action: { })
                    ],
                header: nil,
                footer: nil
            )
        ]
    }

}
