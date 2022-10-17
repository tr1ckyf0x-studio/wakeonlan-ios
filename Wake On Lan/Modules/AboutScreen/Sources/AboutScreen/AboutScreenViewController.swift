//
//  AboutScreenViewController.swift
//  AboutScreen
//
//  Created by Vladislav Lisianskii on 24.04.2021.
//  Copyright © 2021 Владислав Лисянский. All rights reserved.
//

import SharedRouter
import UIKit

public final class AboutScreenViewController: UIViewController, Navigates {

    // MARK: - Properties

    var presenter: AboutScreenViewOutput?

    private lazy var aboutScreenView: AboutScreenView = {
        let view = AboutScreenView()
        view.delegate = self
        return view
    }()

    // MARK: - Lifecycle

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
    func configure(with viewModel: AboutScreenViewViewModel) {
        aboutScreenView.configure(with: viewModel)
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
