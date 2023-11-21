//
//  HostListTableManager.swift
//  
//
//  Created by Vladislav Lisianskii on 07.10.2022.
//

import UIKit
import WOLUIComponents

typealias HostListDataSource = UITableViewDiffableDataSource<HostListSection, HostListItem>

protocol ManagesHostListTable: HostListDataSource,
                                UITableViewDelegate,
                                UITableViewDragDelegate,
                                UITableViewDropDelegate {
}

protocol HostListTableManagerDelegate: AnyObject {
    func hostListTableManager(
        _ hostListTableManager: ManagesHostListTable,
        moveRowAt sourceIndexPath: IndexPath,
        to destinationIndexPath: IndexPath
    )
}

final class HostListTableManager: HostListDataSource, ManagesHostListTable {

    typealias CellProvider = ProvidesTableViewCell<HostListItem>

    weak var delegate: HostListTableManagerDelegate?

    init(tableView: UITableView, cellProvider: any CellProvider = HostListCellProvider()) {
        super.init(tableView: tableView, cellProvider: cellProvider.makeTableViewCell)
    }

    override func tableView(
        _ tableView: UITableView,
        moveRowAt sourceIndexPath: IndexPath,
        to destinationIndexPath: IndexPath
    ) {
        delegate?.hostListTableManager(
            self,
            moveRowAt: sourceIndexPath,
            to: destinationIndexPath
        )
    }
}

// MARK: - UITableViewDragDelegate
extension HostListTableManager {
    func tableView(
        _ tableView: UITableView,
        itemsForBeginning session: UIDragSession,
        at indexPath: IndexPath
    ) -> [UIDragItem] {
        [UIDragItem(itemProvider: NSItemProvider())]
    }

}

// MARK: - UITableViewDropDelegate
extension HostListTableManager {
    func tableView(
        _ tableView: UITableView,
        dropSessionDidUpdate session: UIDropSession,
        withDestinationIndexPath destinationIndexPath: IndexPath?
    ) -> UITableViewDropProposal {
        guard session.localDragSession != nil else {
            return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
        }

        return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }

    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) { }
}
