//
//  HostListViewController.swift
//  Wake On Lan
//
//  Created by Владислав Лисянский on 24.04.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit

final class HostListViewController: UIViewController {

    // MARK: - Properties

    var presenter: HostListViewOutput?

    private lazy var hostListView: HostListView = {
        let view = HostListView()
        view.delegate = self
        return view
    }()

    // MARK: - Lifecycle

    override func loadView() {
        view = hostListView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        presenter?.viewDidLoad(self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }

    // MARK: - Private

    private func setupNavigationBar() {
        navigationItem.title = R.string.hostList.hosts()
        navigationItem.rightBarButtonItem = hostListView.addItemButton
        navigationItem.largeTitleDisplayMode = .always
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationBar.barTintColor = R.color.soft()
        navigationBar.prefersLargeTitles = true
        let largeTitleTextAttributes = [NSAttributedString.Key.font: R.font.robotoBold(size: 36)!]
        navigationBar.largeTitleTextAttributes = largeTitleTextAttributes
    }

    private func setupTableView() {
        hostListView.tableView.delegate = presenter?.tableManager
        hostListView.tableView.dataSource = presenter?.tableManager
    }

}

// MARK: - HostListViewInput

extension HostListViewController: HostListViewInput {

    var contentView: StatebleView { hostListView }

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

}
