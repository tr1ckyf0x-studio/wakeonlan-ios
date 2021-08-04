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
        view?.configure(
            with: bundleInfo.displayName,
            appVersion: bundleInfo.version,
            rows: makeRows(from: bundleInfo)
        )
    }
}

// MARK: - Private

private extension AboutScreenPresenter {

    func makeRows(from bundleInfo: BundleInfo) -> [MenuButtonCellViewModel] {
        [
            // TODO: Move to Resources
            .init(title: "Rate App", action: { [weak self] in
                self?.reviewRequester.requestReview()
            }),
            // TODO: Move to Resources
            .init(title: "GitHub", action: { [weak self] in
                guard let url = URL(string: Configuration.gitHubURL) else { return }
                self?.urlOpener.open(url: url)
            }),
            // TODO: Move to Resources
            .init(title: "Share App", action: { [weak self] in
                self?.view?.displayShareApp(with: Configuration.appStoreURL)
            })
        ]
    }
}
