//
//  AboutScreenPresenter.swift
//  AboutScreen
//
//  Created by Vladislav Lisianskii on 24.04.2021.
//  Copyright © 2021 Владислав Лисянский. All rights reserved.
//

import SharedRouter
import SharedProtocolsAndModels
import StoreKit
import UIKit
import WOLResources

final class AboutScreenPresenter: Navigates {

    // MARK: - Configuration

    enum Configuration {
        static let appStoreURL = "https://itunes.apple.com/us/app/awake-wake-on-lan/id1575138731"
        static let gitHubURL = "https://github.com/tr1ckyf0x/wakeonlan-ios"
    }

    // MARK: - Properties

    weak var view: AboutScreenViewInput?

    var interactor: AboutScreenInteractorInput?
    var router: AboutScreenRoutes?

    private let reviewRequester: RequestsReview.Type
    private let urlOpener: OpensURL

    // MARK: - Init

    init(
        reviewRequester: RequestsReview.Type = SKStoreReviewController.self,
        urlOpener: OpensURL = UIApplication.shared
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
        navigate(to: router?.backOrDismiss(animated: true))
    }
}

// MARK: - AboutScreenInteractorOutput

extension AboutScreenPresenter: AboutScreenInteractorOutput {
    func interactor(_ interactor: AboutScreenInteractorInput, didFetchBundleInfo bundleInfo: BundleInfo) {
        view?.configure(with: makeViewModel(from: bundleInfo))
    }
}

// MARK: - Private

private extension AboutScreenPresenter {
    func makeViewModel(from bundleInfo: BundleInfo) -> AboutScreenViewViewModel {
        .init(
            headerViewModel: .init(
                name: bundleInfo.displayName,
                version: bundleInfo.version
            ),
            buttonListViewModel: [
                .init(
                    title: L10n.AboutScreen.rateApp,
                    symbol: ButtonIcon.star,
                    action: { [weak self] in
                        self?.reviewRequester.requestReview()
                    }
                ),
                .init(
                    title: L10n.AboutScreen.github,
                    symbol: ButtonIcon.tag,
                    action: { [weak self] in
                        guard let url = URL(string: Configuration.gitHubURL) else { return }
                        self?.urlOpener.open(url: url)
                    }
                ),
                .init(
                    title: L10n.AboutScreen.shareApp,
                    symbol: ButtonIcon.share,
                    action: { [weak self] in
                        self?.view?.displayShareApp(with: Configuration.appStoreURL)
                    }
                )
            ]
        )
    }
}
