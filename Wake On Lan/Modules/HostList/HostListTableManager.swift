//
//  HostListTableManager.swift
//  Wake on LAN
//
//  Created by Владислав Лисянский on 21.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit

protocol HostListTableManagerDelegate: AnyObject {

    func tableManagerDidTapInfoButton(_ tableManager: HostListTableManager, host: Host)

    func tableManagerDidTapDeleteButton(_ tableManager: HostListTableManager, host: Host)

    func tableManagerDidTapHostCell(_ tableManager: HostListTableManager, host: Host)

}

final class HostListTableManager: NSObject {

    // MARK: - Properties

    private var sections: [HostListSectionModel] { dataStore.sections }

    var itemsCount: Int { sections.reduce(.zero, { $0 + $1.items.count }) }

    var dataStore = HostListDataStore()

    weak var delegate: HostListTableManagerDelegate?

    func update(with content: [Content]) {
        content.forEach {
            switch $0 {
            case let .insert(indexPath, object):
                dataStore.insertObject(
                    object,
                    at: indexPath.row,
                    in: indexPath.section
                )

            case let .update(indexPath, object):
                dataStore.updateObject(
                    object,
                    at: indexPath.row,
                    in: indexPath.section
                )

            case let .move(oldIndexPath, newIndexPath):
                dataStore.moveObject(
                    from: oldIndexPath.row,
                    to: newIndexPath.row,
                    in: oldIndexPath.section
                )

            case let .delete(indexPath):
                dataStore.removeObject(
                    at: indexPath.row,
                    in: indexPath.section
                )
            }
        }
    }

}

extension HostListTableManager: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        sections[section].items.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        let model = sections[indexPath.section].items[indexPath.row]
        switch model {
        case let .host(host):
            let hostCell = tableView.dequeueReusableCell(
                withIdentifier: "\(HostListTableViewCell.self)",
                for: indexPath) as? HostListTableViewCell
            hostCell?.configure(with: host, delegate: self)
            cell = hostCell
        }

        guard let unwrappedCell = cell else { fatalError("Unknown cell identifier") }

        return unwrappedCell
    }

}

extension HostListTableManager: UITableViewDelegate {

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].header
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        sections[section].footer
    }

}

extension HostListTableManager: HostListTableViewCellDelegate {

    func hostListCellDidTap(_ cell: HostListTableViewCell, model: Host) {
        delegate?.tableManagerDidTapHostCell(self, host: model)
    }

    func hostListCellDidTapDelete(_ cell: HostListTableViewCell, model: Host) {
        delegate?.tableManagerDidTapDeleteButton(self, host: model)
    }

    func hostListCellDidTapInfo(_ cell: HostListTableViewCell, model: Host) {
        delegate?.tableManagerDidTapInfoButton(self, host: model)
    }

}
