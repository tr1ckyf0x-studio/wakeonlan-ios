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

    // MARK: - Configuration

    enum Configuration {
        static let appStoreURL = "https://itunes.apple.com/us/app/awake-wake-on-lan/id1575138731"
        static let gitHubURL = "https://github.com/tr1ckyf0x/wakeonlan-ios"
    }

    // MARK: - Properties

    weak var view: AboutScreenViewInput?

    var interactor: AboutScreenInteractorInput?

    var router: AboutScreenRouter?

    private let reviewRequester: RequestsReview

    private let urlOpener: OpensURL

    // MARK: - Init

    init(
        reviewRequester: RequestsReview = ReviewRequester(),
        urlOpener: OpensURL = URLOpener()
    ) {
        self.reviewRequester = reviewRequester
        self.urlOpener = urlOpener
    }
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
        let sections = makeSections(from: bundleInfo)
        view?.configure(with: sections)
    }
}

// MARK: - Private

private extension AboutScreenPresenter {

    func makeSections(from bundleInfo: BundleInfo) -> [AboutScreenSectionModel] {
        let rows: [MenuButtonCellViewModel] = [
            .init(title: L10n.AboutScreen.rateApp, symbol: ButtonIcon.star, action: { [weak self] in
                self?.reviewRequester.requestReview()
            }),
            .init(title: L10n.AboutScreen.github, symbol: ButtonIcon.tag, action: { [weak self] in
                guard let url = URL(string: Configuration.gitHubURL) else { return }
                self?.urlOpener.open(url: url)
            }),
            .init(title: L10n.AboutScreen.shareApp, symbol: ButtonIcon.share, action: { [weak self] in
                self?.view?.displayShareApp(with: Configuration.appStoreURL)
            })
        ]

        let cellViewModels = rows.map { (cellViewModel: MenuButtonCellViewModel) -> AboutScreenSectionItem in
            AboutScreenSectionItem.menuButton(cellViewModel)
        }

        let mainSection = AboutScreenSectionModel.mainSection(
            content: cellViewModels,
            appName: bundleInfo.displayName,
            appVersion: bundleInfo.version
        )

        return [mainSection]
    }
}
