//
//  HostListViewController.swift
//  Wake On Lan
//
//  Created by Владислав Лисянский on 24.04.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit
import WOLResources
import WOLUIComponents

public final class HostListViewController: UIViewController {

    // MARK: - Properties

    var presenter: HostListViewOutput?

    private lazy var hostListView: HostListView = {
        let view = HostListView()
        view.delegate = self
        return view
    }()

    private lazy var tableManager: ManagesHostListTable = HostListTableManager(
        tableView: hostListView.tableView,
        hostCellDelegate: self
    )

    // MARK: - Lifecycle

    override public func loadView() {
        view = hostListView
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        presenter?.viewDidLoad(self)
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }

    // MARK: - Private

    private func setupNavigationBar() {
        navigationItem.title = L10n.HostList.hosts
        navigationItem.rightBarButtonItems = [hostListView.addItemButton,
                                              hostListView.barButtonSpacer,
                                              hostListView.aboutButton]
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.leftBarButtonItem = hostListView.sortItemsButton
        guard let navigationController else { return }
        navigationController.view.backgroundColor = Asset.Colors.primary.color
        let navigationBar = navigationController.navigationBar
        navigationBar.prefersLargeTitles = true
    }

}

// MARK: - HostListViewInput

extension HostListViewController: HostListViewInput {

    func showState(_ state: ViewState) {
        hostListView.showState(state)
    }

    func updateContentSnapshot(_ contentSnapshot: ContentSnapshot) {
        tableManager.apply(snapshot: contentSnapshot)
    }

}

// MARK: - HostListViewDelegate

extension HostListViewController: HostListViewDelegate {
    func hostListViewDidPressSortButton(_ view: HostListView) {
        presenter?.viewDidPressSortButton(self)
    }

    func hostListViewDidPressAddButton(_ view: HostListView) {
        presenter?.viewDidPressAddButton(self)
    }

    func hostListViewDidPressAboutButton(_ view: HostListView) {
        presenter?.viewDidPressAboutButton(self)
    }

}

// MARK: - HostListTableViewCellDelegate

extension HostListViewController: HostListTableViewCellDelegate {

    func hostListCellDidTap(_ cell: HostListTableViewCell) {
        guard let indexPath = hostListView.tableView.indexPath(for: cell) else { return }
        presenter?.viewDidPressHostCell(self, for: indexPath)
    }

    func hostListCellDidTapDelete(_ cell: HostListTableViewCell) {
        guard let indexPath = hostListView.tableView.indexPath(for: cell) else { return }
        presenter?.viewDidPressDeleteButton(self, for: indexPath)
    }

    func hostListCellDidTapInfo(_ cell: HostListTableViewCell) {
        guard let indexPath = hostListView.tableView.indexPath(for: cell) else { return }
        presenter?.viewDidPressInfoButton(self, for: indexPath)
    }

}
