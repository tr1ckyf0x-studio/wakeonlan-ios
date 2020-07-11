//
//  AddHostViewController.swift
//  Wake On Lan
//
//  Created by Владислав Лисянский on 27.04.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit

class AddHostViewController: UIViewController {
    
    // MARK: - Properties
    var presenter: (AddHostViewOutput & ChooseIconModuleOutput)?

    private lazy var addHostView: AddHostView = {
        let view = AddHostView()
        view.delegate = self
        return view
    }()
    
    // MARK: - Lifecycle
    override func loadView() {
        view = addHostView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AddHostConfigurator().configure(viewController: self)
        setupTableView()
        setupNavigationBar()
        presenter?.viewDidLoad(self)
    }

    // MARK: - Private
    private func setupTableView() {
        addHostView.tableView.delegate = presenter?.tableManager
        addHostView.tableView.dataSource = presenter?.tableManager
    }

    private func setupNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.leftBarButtonItem = addHostView.backBarButton
        navigationItem.rightBarButtonItem = addHostView.saveItemButton
    }

}

extension AddHostViewController: AddHostViewInput {
    func reloadTable() {
        addHostView.tableView.reloadData()
    }
}

extension AddHostViewController: AddHostViewDelegate {
    func addHostViewDidPressBackButton(_ view: AddHostView) {
        presenter?.viewDidPressBackButton(self)
    }
    
    func addHostViewDidPressSaveButton(_ view: AddHostView) {
        presenter?.viewDidPressSaveButton(self)
    }
}
