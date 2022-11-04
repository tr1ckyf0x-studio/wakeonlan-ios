//
//  HostListTableManager.swift
//  
//
//  Created by Vladislav Lisianskii on 07.10.2022.
//

import UIKit

protocol SnapshotTableManager<SnapshotSectionIdentifier, SnapshotItemIdentifier> {
    associatedtype SnapshotSectionIdentifier: Hashable
    associatedtype SnapshotItemIdentifier: Hashable

    func apply(snapshot: NSDiffableDataSourceSnapshot<SnapshotSectionIdentifier, SnapshotItemIdentifier>)
}

final class HostListTableManager {

    typealias DataSource = UITableViewDiffableDataSource<SnapshotSectionIdentifier, SnapshotItemIdentifier>

    private let tableView: UITableView

    private weak var hostCellDelegate: HostListTableViewCellDelegate?

    private lazy var dataSource = DataSource(
        tableView: tableView,
        cellProvider: configureCellClosure
    )

    init(tableView: UITableView, hostCellDelegate: HostListTableViewCellDelegate?) {
        self.tableView = tableView
        self.hostCellDelegate = hostCellDelegate
    }

    private lazy var configureCellClosure = { [weak self] (
        tableView: UITableView,
        indexPath: IndexPath,
        model: HostListSectionItem
    ) -> UITableViewCell? in
        var cell: UITableViewCell?
        if case let .host(viewModel) = model {
            let hostCell = tableView.dequeueReusableCell(
                withIdentifier: "\(HostListTableViewCell.self)",
                for: indexPath
            ) as? HostListTableViewCell
            hostCell?.configure(with: viewModel, delegate: self?.hostCellDelegate)
            cell = hostCell
        }
        return cell
    }
}

// MARK: - SnapshotTableManager
extension HostListTableManager: SnapshotTableManager {
    typealias SnapshotSectionIdentifier = String
    typealias SnapshotItemIdentifier = HostListSectionItem

    func apply(snapshot: NSDiffableDataSourceSnapshot<SnapshotSectionIdentifier, SnapshotItemIdentifier>) {
        dataSource.apply(snapshot)
    }
}
