//
//  AboutScreenContract.swift
//  AboutScreen
//
//  Created by Vladislav Lisianskii on 24.04.2021.
//  Copyright © 2021 Vladislav Lisianskii. All rights reserved.
//

@MainActor
protocol AboutScreenViewOutput: AnyObject {
    func viewDidLoad(_ view: AboutScreenViewInput)
    func viewDidPressBackButton(_ view: AboutScreenViewInput)
}

@MainActor
protocol AboutScreenViewInput: AnyObject {
    func configure(with viewModel: AboutScreenViewViewModel)
    func displayShareApp(with appURL: String)
}

@MainActor
protocol AboutScreenInteractorInput: AnyObject {
    func fetchBundleInfo()
}

@MainActor
protocol AboutScreenInteractorOutput: AnyObject {
    func interactor(_ interactor: AboutScreenInteractorInput, didFetchBundleInfo bundleInfo: BundleInfo)
}
