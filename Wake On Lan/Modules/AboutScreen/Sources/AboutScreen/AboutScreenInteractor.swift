//
//  AboutScreenInteractor.swift
//  AboutScreen
//
//  Created by Vladislav Lisianskii on 24.04.2021.
//  Copyright © 2021 Владислав Лисянский. All rights reserved.
//

import WOLResources

final class AboutScreenInteractor {
    // MARK: - Properties

    weak var presenter: AboutScreenInteractorOutput?

    private let bundleInfoProvider: ProvidesBundleInfo

    // MARK: - Init

    init(bundleInfoProvider: ProvidesBundleInfo = BundleInfoProvider()) {
        self.bundleInfoProvider = bundleInfoProvider
    }
}

// MARK: - AboutScreenInteractorInput

extension AboutScreenInteractor: AboutScreenInteractorInput {
    func fetchBundleInfo() {
        let bundleInfo = bundleInfoProvider.fetchBundleInfo()
        presenter?.interactor(self, didFetchBundleInfo: bundleInfo)
    }
}
