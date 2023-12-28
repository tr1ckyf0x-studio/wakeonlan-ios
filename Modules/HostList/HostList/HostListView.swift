//
//  HostListView.swift
//  Wake On Lan
//
//  Created by Vladislav Lisianskii on 24.04.2020.
//  Copyright © 2020 Vladislav Lisianskii. All rights reserved.
//

import UIKit
import WOLResources
import WOLUIComponents

protocol HostListViewDelegate: AnyObject {
    func hostListViewDidPressAddButton(_ view: DisplaysHostList)
    func hostListViewDidPressAboutButton(_ view: DisplaysHostList)
    func hostListView(_ view: DisplaysHostList, didTapDeleteAt indexPath: IndexPath)
    func hostListView(_ view: DisplaysHostList, didTapInfoAt indexPath: IndexPath)
    func hostListView(_ view: DisplaysHostList, didTapCellAt indexPath: IndexPath)
    func hostListView(
        _ view: DisplaysHostList,
        moveRowAt sourceIndexPath: IndexPath,
        to destinationIndexPath: IndexPath
    )
}

protocol DisplaysHostList {
    func updateContentSnapshot(_ contentSnapshot: HostListSnapshot)
}

final class HostListView: UIView {

    // MARK: - Constants

    private enum Constants {
        static let barButtonDimensions = 32.0
        static let barButtonSpacing: CGFloat = 16.0
    }

    // MARK: - Properties

    weak var delegate: HostListViewDelegate?

    lazy var tableView: UITableView = {
        let tableView = UITableView(
            frame: .zero,
            style: .grouped
        )
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = Asset.Colors.primary.color
        tableView.dragInteractionEnabled = true

        return tableView
    }()

    private lazy var tableManager: ManagesHostListTable = {
        let tableManager = HostListTableManager(
            tableView: tableView,
            cellProvider: HostListCellProvider(hostCellDelegate: self)
        )
        tableManager.delegate = self
        return tableManager
    }()

    lazy var emptyView: EmptyView = {
        let emptyView = EmptyView()
        let viewModel = StateableViewModel(
            title: L10n.HostList.Screen.emptyViewMessage,
            image: Asset.Assets.owl.image,
            backgroundColor: Asset.Colors.primary.color
        )
        emptyView.configure(with: viewModel)

        return emptyView
    }()

    lazy var aboutButton: UIBarButtonItem = {
        let aboutButton: SoftUIView = {
            let button = SoftUIView(circleShape: true)
            let image = UIImage(sfSymbol: ButtonIcon.questionmark, withConfiguration: .init(weight: .semibold))
            let imageView = UIImageView(image: image)
            imageView.tintColor = Asset.Colors.secondary.color
            button.configure(with: SoftUIViewModel(contentView: imageView))
            button.addTarget(self, action: #selector(didTapAboutButton(_:)), for: .touchUpInside)
            imageView.snp.makeConstraints {
                $0.center.equalToSuperview()
            }

            return button
        }()

        let barButton: UIBarButtonItem = {
            let button = UIBarButtonItem(customView: aboutButton)
            button.customView?.snp.makeConstraints {
                $0.size.equalTo(Constants.barButtonDimensions)
            }

            return button
        }()

        return barButton
    }()

    lazy var barButtonSpacer: UIBarButtonItem = {
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacer.width = Constants.barButtonSpacing
        return spacer
    }()

    lazy var addItemButton: UIBarButtonItem = {
        let addButton: SoftUIView = {
            let button = SoftUIView(circleShape: true)
            let image = UIImage(sfSymbol: ButtonIcon.plus, withConfiguration: .init(weight: .semibold))
            let imageView = UIImageView(image: image)
            imageView.tintColor = WOLResources.Asset.Colors.secondary.color
            button.configure(with: SoftUIViewModel(contentView: imageView))
            button.addTarget(self, action: #selector(didTapAddButton(_:)), for: .touchUpInside)
            imageView.snp.makeConstraints {
                $0.edges.equalToSuperview().inset(6)
            }

            return button
        }()

        let barButton: UIBarButtonItem = {
            let button = UIBarButtonItem(customView: addButton)
            button.customView?.snp.makeConstraints {
                $0.size.equalTo(Constants.barButtonDimensions)
            }

            return button
        }()

        return barButton
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        makeConstraints()
        makeAppearance()
        setupTableView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private

private extension HostListView {

    func addSubviews() {
        addSubview(tableView)
    }

    func makeConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }

    func makeAppearance() {
        backgroundColor = Asset.Colors.primary.color
    }

    func setupTableView() {
        tableView.delegate = tableManager
        tableView.dragDelegate = tableManager
        tableView.dropDelegate = tableManager
    }

    @objc func didTapAddButton(_ sender: UIButton) {
        delegate?.hostListViewDidPressAddButton(self)
    }

    @objc func didTapAboutButton(_ sender: UIButton) {
        delegate?.hostListViewDidPressAboutButton(self)
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

// MARK: - DisplaysHostList

extension HostListView: DisplaysHostList {
    func updateContentSnapshot(_ contentSnapshot: HostListSnapshot) {
        tableManager.apply(contentSnapshot)
    }
}

// MARK: - HostListTableViewCellDelegate

extension HostListView: HostListTableViewCellDelegate {
    func hostListCellDidTap(_ cell: HostListTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        delegate?.hostListView(self, didTapCellAt: indexPath)
    }

    func hostListCellDidTapDelete(_ cell: HostListTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        delegate?.hostListView(self, didTapDeleteAt: indexPath)
    }

    func hostListCellDidTapInfo(_ cell: HostListTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        delegate?.hostListView(self, didTapInfoAt: indexPath)
    }
}

// MARK: - HostListTableManagerDelegate

extension HostListView: HostListTableManagerDelegate {
    func hostListTableManager(
        _ hostListTableManager: ManagesHostListTable,
        moveRowAt sourceIndexPath: IndexPath,
        to destinationIndexPath: IndexPath
    ) {
        delegate?.hostListView(
            self,
            moveRowAt: sourceIndexPath,
            to: destinationIndexPath
        )
    }
}
