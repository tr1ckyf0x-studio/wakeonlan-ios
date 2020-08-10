//
//  HostListViewController.swift
//  Wake On Lan
//
//  Created by Владислав Лисянский on 24.04.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit

class HostListViewController: UIViewController {

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
        HostListConfigurator().configure(viewController: self)
        setupTableView()
        presenter?.viewIsReady(self)
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
        navigationBar.barTintColor = .softUIColor
        navigationBar.prefersLargeTitles = true
        let largeTitleTextAttributes = [NSAttributedString.Key.font : R.font.robotoBold(size: 36)!]
        navigationBar.largeTitleTextAttributes = largeTitleTextAttributes
    }
    
    private func setupTableView() {
        hostListView.tableView.delegate = presenter?.tableManager
        hostListView.tableView.dataSource = presenter?.tableManager
    }

}

// MARK: - HostListViewInput
extension HostListViewController: HostListViewInput {

    func reloadTable() {
        hostListView.tableView.reloadData()
    }

    func updateTable(with update: Content) {
        let tableView = hostListView.tableView
        tableView.performBatchUpdates({
            switch update {
                case .insert(let indexPath, _):
                    tableView.insertRows(at: [indexPath], with: .automatic)
                case .update(let indexPath, _):
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                case .move(old: let indexPath, new: let newIndexPath):
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                    tableView.insertRows(at: [newIndexPath], with: .automatic)
                case .delete(let indexPath):
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
