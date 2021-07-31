//
//  AboutScreenInteractor.swift
//  AboutScreen
//
//  Created by Vladislav Lisianskii on 24.04.2021.
//  Copyright © 2021 Владислав Лисянский. All rights reserved.
//

import Foundation
import WOLResources

final class AboutScreenInteractor {

    // MARK: - Properties

    weak var presenter: AboutScreenInteractorOutput?

    private let bundleInfoProvider: ProvidesBundleInfo

    init(bundleInfoProvider: ProvidesBundleInfo = BundleInfoProvider()) {
        self.bundleInfoProvider = bundleInfoProvider
    }

}

// MARK: - AboutScreenInteractorInput

extension AboutScreenInteractor: AboutScreenInteractorInput {

    func fetchBundleInfo() {
        bundleInfoProvider.fetchBundleInfo { [weak self] info in
            guard let self = self else { return }
            self.presenter?.interactor(self, didFetchBundleInfo: info)
        }
    }

}
