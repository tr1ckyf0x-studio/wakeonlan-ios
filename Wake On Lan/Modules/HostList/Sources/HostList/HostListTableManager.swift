//
//  HostListTableManager.swift
//  
//
//  Created by Vladislav Lisianskii on 07.10.2022.
//

import UIKit

protocol ManagesHostListTable {
    typealias Snapshot = NSDiffableDataSourceSnapshot<String, HostListSectionItem>

    func apply(snapshot: Snapshot)
}

final class HostListTableManager {

    typealias DataSource = UITableViewDiffableDataSource<String, HostListSectionItem>

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
extension HostListTableManager: ManagesHostListTable {

    func apply(snapshot: Snapshot) {
        dataSource.apply(snapshot)
    }
}
