//
//  HostListView.swift
//  Wake On Lan
//
//  Created by Владислав Лисянский on 24.04.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit
import SnapKit
import WOLUIComponents
import WOLResources

protocol HostListViewDelegate: class {
    func hostListViewDidPressAddButton(_ view: HostListView)
}

final class HostListView: UIView {

    // MARK: - Constants

    private enum Constants {
        static let addItemButtonDimensions = 32.0
    }

    // MARK: - Properties

    weak var delegate: HostListViewDelegate?

    lazy var tableView: UITableView = {
        let tableView = UITableView(
            frame: .zero,
            style: .grouped
        )
        tableView.register(
            HostListTableViewCell.self,
            forCellReuseIdentifier: "\(HostListTableViewCell.self)"
        )
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension

        return tableView
    }()

    lazy var emptyView: EmptyView = {
        let emptyView = EmptyView()
        let viewModel = StateableViewModel(
            title: R.string.wakeOnLan.emptyViewMessage(),
            image: R.image.droids(),
            backgroundColor: R.color.soft()
        )
        emptyView.configure(with: viewModel)

        return emptyView
    }()

    // swiftlint:disable closure_body_length
    lazy var addItemButton: UIBarButtonItem = {
        let addButton: SoftUIButton = {
            let button = SoftUIButton(cornerRadius: 16.0)
            button.setImage(
                R.image.add(),
                for: .normal
            )
            button.addTarget(
                self,
                action: #selector(didTapAddButton(_:)),
                for: .touchUpInside
            )
            let spacing: CGFloat = 5
            button.imageEdgeInsets = .init(
                top: spacing,
                left: spacing,
                bottom: spacing,
                right: spacing
            )

            return button
        }()

        let barButton: UIBarButtonItem = {
            let button = UIBarButtonItem(customView: addButton)
            button.customView?.snp.makeConstraints {
                $0.size.equalTo(Constants.addItemButtonDimensions)
            }

            return button
        }()

        return barButton
    }()
    // swiftlint:enable closure_body_length

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = R.color.soft()
        setupTableView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Private

private extension HostListView {

    func setupTableView() {
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }

    @objc func didTapAddButton(_ sender: UIButton) {
        delegate?.hostListViewDidPressAddButton(self)
    }

}

// MARK: - ContentStateView

extension HostListView: StateableView {

    func view(for state: ViewState) -> DisplaysStateView? {
        switch state {
        case .default, .error, .waiting:
            return nil

        case .empty:
            return emptyView
        }
    }

}
