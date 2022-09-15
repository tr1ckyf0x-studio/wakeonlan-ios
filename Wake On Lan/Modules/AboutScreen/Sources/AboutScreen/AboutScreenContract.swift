//
//  AboutScreenContract.swift
//  AboutScreen
//
//  Created by Vladislav Lisianskii on 24.04.2021.
//  Copyright © 2021 Владислав Лисянский. All rights reserved.
//

import WOLResources

protocol AboutScreenViewOutput: AnyObject {
    func viewDidLoad(_ view: AboutScreenViewInput)

    func viewDidPressBackButton(_ view: AboutScreenViewInput)
}
// sourcery: AutoMockable
protocol AboutScreenViewInput: AnyObject {
    func configure(with viewModel: AboutScreenViewViewModel)

    func displayShareApp(with appURL: String)
}
// sourcery: AutoMockable
protocol AboutScreenInteractorInput: AnyObject {
    func fetchBundleInfo()
}

// sourcery: AutoMockable
protocol AboutScreenInteractorOutput: AnyObject {
    func interactor(_ interactor: AboutScreenInteractorInput, didFetchBundleInfo bundleInfo: BundleInfo)
}
