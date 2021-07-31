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
        setupTableView()
    }

}

// MARK: - Private methods
private extension AboutScreenViewController {

    func setupNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.leftBarButtonItem = aboutScreenView.backBarButton
    }

    private func setupTableView() {
        aboutScreenView.tableView.delegate = presenter?.tableManager
        aboutScreenView.tableView.dataSource = presenter?.tableManager
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
}
