//
//  HostListViewController.swift
//  Wake On Lan
//
//  Created by Владислав Лисянский on 24.04.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit
import WOLUIComponents
import WOLResources

public final class HostListViewController: UIViewController {

    // MARK: - Properties

    var presenter: HostListViewOutput?

    private lazy var hostListView: HostListView = {
        let view = HostListView()
        view.delegate = self
        return view
    }()

    // MARK: - Lifecycle

    override public func loadView() {
        view = hostListView
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        edgesForExtendedLayout = []
        presenter?.viewDidLoad(self)
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }

    // MARK: - Private

    private func setupNavigationBar() {
        navigationItem.title = WOLResources.L10n.HostList.hosts
        navigationItem.rightBarButtonItems = [hostListView.addItemButton,
                                              hostListView.barButtonSpacer,
                                              hostListView.aboutButton]
        navigationItem.largeTitleDisplayMode = .always
        guard let navigationController = navigationController else { return }
        navigationController.view.backgroundColor = WOLResources.Asset.Colors.soft.color
        let navigationBar = navigationController.navigationBar
        navigationBar.prefersLargeTitles = true
        let largeTitleTextAttributes = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 36)
        ]
        navigationBar.largeTitleTextAttributes = largeTitleTextAttributes
    }

    private func setupTableView() {
        hostListView.tableView.delegate = presenter?.tableManager
        hostListView.tableView.dataSource = presenter?.tableManager
    }

}

// MARK: - HostListViewInput

extension HostListViewController: HostListViewInput {

    var contentView: StateableView { hostListView }

    func reloadTable() {
        hostListView.tableView.reloadData()
    }

    func updateTable(with update: Content) {
        let tableView = hostListView.tableView
        tableView.performBatchUpdates({
            switch update {
            case let .insert(indexPath, _):
                tableView.insertRows(at: [indexPath], with: .automatic)

            case let .update(indexPath, _):
                tableView.reloadRows(at: [indexPath], with: .automatic)

            case let .move(indexPath, newIndexPath):
                tableView.moveRow(at: indexPath, to: newIndexPath)

            case let .delete(indexPath):
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        })
    }

}

// MARK: - HostListViewDelegate

extension HostListViewController: HostListViewDelegate {

    func hostListViewDidPressAddButton(_ view: HostListView) {
        presenter?.viewDidPressAddButton(self)
    }

    func hostListViewDidPressAboutButton(_ view: HostListView) {
        presenter?.viewDidPressAboutButton(self)
    }

}
