//
//  DonateScreenViewController.swift
//  
//
//  Created by Vladislav Lisianskii on 14.04.2023.
//

import UIKit

public final class DonateScreenViewController: UIViewController {

    // MARK: - Properties

    var presenter: DonateScreenViewOutput?

    private lazy var rootView: DonateScreenView = { view in
        view.delegate = self
        return view
    }(DonateScreenView())

    private lazy var tableManager: ManagesDonateScreenTable = {
        let tableManager = DonateScreenTableManager()
        rootView.tableView.dataSource = tableManager
        rootView.tableView.delegate = tableManager

        return tableManager
    }()

    // MARK: - Lifecycle

    override public func loadView() {
        view = rootView
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        presenter?.viewDidLoad(self)
    }
}

// MARK: - Private
extension DonateScreenViewController {
    private func setupNavigationBar() {
        title = L10n.DonateScreen.title
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.leftBarButtonItem = rootView.backBarButton
    }
}

// MARK: - DonateScreenViewInput
extension DonateScreenViewController: DonateScreenViewInput {

    func setSections(_ sections: [DonateScreenTableSectionModel]) {
        tableManager.sections = sections
        rootView.tableView.reloadData()
    }

    func showState(_ state: DonateScreenState) {
        rootView.stateViews.forEach { $0.isHidden = true }
        rootView.spinnerView.stopAnimating()

        switch state {
        case .paymentsUnavailable:
            rootView.paymentsUnavailableView.isHidden = false

        case .loading:
            rootView.spinnerView.isHidden = false
            rootView.spinnerView.startAnimating()

        case .loaded:
            rootView.tableView.isHidden = false
        }
    }
}

// MARK: - DonateScreenViewDelegate
extension DonateScreenViewController: DonateScreenViewDelegate {
    func donateScreenViewDidPressBackButton(_ view: DonateScreenView) {
        presenter?.viewDidPressBackButton(self)
    }
}
