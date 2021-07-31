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

protocol HostListViewDelegate: AnyObject {
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
        tableView.backgroundColor = WOLResources.Asset.Colors.soft.color

        return tableView
    }()

    lazy var emptyView: EmptyView = {
        let emptyView = EmptyView()
        let viewModel = StateableViewModel(
            title: WOLResources.L10n.WakeOnLan.emptyViewMessage,
            image: WOLResources.Asset.Assets.owl.image,
            backgroundColor: WOLResources.Asset.Colors.soft.color
        )
        emptyView.configure(with: viewModel)

        return emptyView
    }()

    // swiftlint:disable closure_body_length
    lazy var addItemButton: UIBarButtonItem = {
        let addButton: SoftUIView = {
            let button = SoftUIView(circleShape: true)
            let image = UIImage(sfSymbol: .plus, withConfiguration: .init(weight: .semibold))
            let imageView = UIImageView(image: image)
            imageView.tintColor = WOLResources
                .Asset
                .Colors
                .lightGray
                .color
            button.configure(with: SoftUIViewModel(contentView: imageView))
            button.addTarget(
                self,
                action: #selector(didTapAddButton(_:)),
                for: .touchUpInside
            )
            imageView.snp.makeConstraints {
                $0.edges.equalToSuperview().inset(6)
            }

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

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = WOLResources.Asset.Colors.soft.color
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
