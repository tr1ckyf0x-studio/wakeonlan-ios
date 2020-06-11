//
//  AddHostViewController.swift
//  Wake On Lan
//
//  Created by Владислав Лисянский on 27.04.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit

class AddHostViewController: UIViewController {
    
    var presenter: (AddHostViewOutput & ChooseIconModuleOutput)?
    
    private lazy var addHostView = AddHostView()
    
    override func loadView() {
        view = addHostView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let configurator = AddHostConfigurator()
        configurator.configure(viewController: self)
        addHostView.delegate = self
        setupViews()
        presenter?.viewDidLoad(self)
    }
    
    private func setupViews() {
        setupTableView()
        setupNavigationBar()
    }
    
    private func setupTableView() {
        addHostView.tableView.dataSource = presenter?.tableManager
        addHostView.tableView.delegate = presenter?.tableManager
    }
    
    private func setupNavigationBar() {
        setupSaveButton()
    }
    
    private func setupSaveButton() {
        navigationItem.rightBarButtonItem = addHostView.saveItemButton
    }
}

extension AddHostViewController: AddHostViewInput {
    func reloadTable() {
        addHostView.tableView.reloadData()
    }
}

extension AddHostViewController: AddHostViewDelegate {
    func addHostViewDidPressSaveButton(_ view: AddHostView) {
        presenter?.viewDidPressSaveButton(self)
    }
}
