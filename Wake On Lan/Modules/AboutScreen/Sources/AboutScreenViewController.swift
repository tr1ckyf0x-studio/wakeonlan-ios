//
//  AboutScreenViewController.swift
//  AboutScreen
//
//  Created by Vladislav Lisianskii on 24.04.2021.
//  Copyright © 2021 Владислав Лисянский. All rights reserved.
//

import UIKit

public final class AboutScreenViewController: UIViewController {

    // MARK: - Properties

    var presenter: AboutScreenViewOutput?

    private lazy var aboutScreenView: AboutScreenView = {
        let view = AboutScreenView()
        view.delegate = self
        view.configureTableView(with: tableManager)
        return view
    }()

    private let tableManager: ManagingAboutScreenTable

    // MARK: - Lifecycle

    public init(with manager: ManagingAboutScreenTable = AboutScreenTableManager()) {
        tableManager = manager
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func loadView() {
        view = aboutScreenView
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad(self)
        setupNavigationBar()
    }
}

// MARK: - AboutScreenViewDelegate

extension AboutScreenViewController: AboutScreenViewDelegate {

    func aboutScreenViewDidPressBackButton(_ view: AboutScreenView) {
        presenter?.viewDidPressBackButton(self)
    }
}

// MARK: - AboutScreenViewInput

extension AboutScreenViewController: AboutScreenViewInput {

    func configure(with sections: [AboutScreenSectionModel]) {
        tableManager.sections = sections
        aboutScreenView.reloadData()
    }

    func displayShareApp(with appURL: String) {
        let viewController = UIActivityViewController(
            activityItems: [appURL],
            applicationActivities: nil
        )
        viewController.popoverPresentationController?.sourceView = view
        viewController.excludedActivityTypes = [.airDrop, .addToReadingList]

        present(viewController, animated: true)
    }

}

// MARK: - Private

private extension AboutScreenViewController {

    func setupNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.leftBarButtonItem = aboutScreenView.backBarButton
    }

}
