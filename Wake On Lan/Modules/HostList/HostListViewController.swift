//
//  HostListViewController.swift
//  Wake On Lan
//
//  Created by Владислав Лисянский on 24.04.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit

class HostListViewController: UIViewController {
    
    var presenter: HostListViewOutput?
    
    private lazy var hostListView = HostListView()
    
    override func loadView() {
        view = hostListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let configurator = HostListConfigurator()
        configurator.configure(viewController: self)
        hostListView.delegate = self
        setupViews()
        presenter?.viewIsReady(self)
    }
    
    private func setupViews() {
        setupNavigationBar()
        setupTableView()
    }
    
    private func setupNavigationBar() {
        setupAddButton()
    }
    
    private func setupTableView() {
        hostListView.tableView.dataSource = presenter?.tableManager
        hostListView.tableView.delegate = presenter?.tableManager
    }
    
    private func setupAddButton() {
        navigationItem.rightBarButtonItem = hostListView.addItemButton
    }
}

extension HostListViewController: HostListViewDelegate {
    func hostListViewDidPressAddButton(_ view: HostListView) {
        presenter?.viewDidPressAddButton(self)
    }
}

extension HostListViewController: HostListViewInput {
    func reloadTable() {
        hostListView.tableView.reloadData()
    }
}
