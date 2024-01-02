//
//  HostListViewController.swift
//  Wake On Lan
//
//  Created by Vladislav Lisianskii on 24.04.2020.
//  Copyright © 2020 Vladislav Lisianskii. All rights reserved.
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
        navigationItem.title = L10n.HostList.Screen.title
        navigationItem.leftBarButtonItem = hostListView.donateButton
        navigationItem.rightBarButtonItems = [hostListView.addItemButton,
                                              hostListView.barButtonSpacer,
                                              hostListView.aboutButton]
        navigationItem.largeTitleDisplayMode = .always
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

    func updateContentSnapshot(_ contentSnapshot: HostListSnapshot) {
        hostListView.updateContentSnapshot(contentSnapshot)
    }
}

// MARK: - HostListViewDelegate

extension HostListViewController: HostListViewDelegate {
    func hostListViewDidPressAddButton(_ view: DisplaysHostList) {
        presenter?.viewDidPressAddButton(self)
    }

    func hostListViewDidPressAboutButton(_ view: DisplaysHostList) {
        presenter?.viewDidPressAboutButton(self)
    }

    func hostListView(_ view: DisplaysHostList, didTapDeleteAt indexPath: IndexPath) {
        presenter?.viewDidPressDeleteButton(self, for: indexPath)
    }

    func hostListView(_ view: DisplaysHostList, didTapInfoAt indexPath: IndexPath) {
        presenter?.viewDidPressInfoButton(self, for: indexPath)
    }

    func hostListView(_ view: DisplaysHostList, didTapCellAt indexPath: IndexPath) {
        presenter?.viewDidPressHostCell(self, for: indexPath)
    }

    func hostListView(
        _ view: DisplaysHostList,
        moveRowAt sourceIndexPath: IndexPath,
        to destinationIndexPath: IndexPath
    ) {
        presenter?.view(
            self,
            moveRowAt: sourceIndexPath,
            to: destinationIndexPath
        )
    }

    func hostListViewDidPressDonateButton(_ view: DisplaysHostList) {
        presenter?.viewDidPressDonateButton(self)
    }
}
