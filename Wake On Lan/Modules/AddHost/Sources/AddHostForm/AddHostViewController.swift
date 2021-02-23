//
//  AddHostViewController.swift
//  Wake On Lan
//
//  Created by Владислав Лисянский on 27.04.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit
import WOLResources

public final class AddHostViewController: UIViewController {

    // MARK: - Properties

    var presenter: (AddHostViewOutput & ChooseIconModuleOutput)?

    private lazy var addHostView: AddHostView = {
        let view = AddHostView()
        view.delegate = self
        return view
    }()

    // MARK: - Lifecycle

    override public func loadView() {
        view = addHostView
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationBar()
        view.backgroundColor = R.color.soft()
        presenter?.viewDidLoad(self)
    }

}

// MARK: - Private

private extension AddHostViewController {
    func setupTableView() {
        addHostView.tableView.delegate = presenter?.tableManager
        addHostView.tableView.dataSource = presenter?.tableManager
    }

    func setupNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.leftBarButtonItem = addHostView.backBarButton
        navigationItem.rightBarButtonItem = addHostView.saveItemButton
    }
}

// MARK: - AddHostViewInput

extension AddHostViewController: AddHostViewInput {
    func reloadTable() {
        addHostView.tableView.reloadData()
    }
}

// MARK: - AddHostViewDelegate

extension AddHostViewController: AddHostViewDelegate {
    func addHostViewDidPressBackButton(_ view: AddHostView) {
        presenter?.viewDidPressBackButton(self)
    }

    func addHostViewDidPressSaveButton(_ view: AddHostView) {
        presenter?.viewDidPressSaveButton(self)
    }
}
