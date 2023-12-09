//
//  HostListCellProvider.swift
//  HostList
//
//  Created by Vladislav Lisianskii on 21.11.2023.
//

import SharedExtensions
import SharedProtocolsAndModels

struct HostListCellProvider: ProvidesTableViewCell {

    private weak var hostCellDelegate: HostListTableViewCellDelegate?

    init(hostCellDelegate: HostListTableViewCellDelegate? = nil) {
        self.hostCellDelegate = hostCellDelegate
    }

    func makeTableViewCell(
        _ tableView: UITableView,
        _ indexPath: IndexPath,
        _ item: HostListSectionItem
    ) -> UITableViewCell? {
        switch item {
        case let .host(viewModel):
            let cell = tableView.dequeueReusableCellWithAutoregistration(HostListTableViewCell.self)
            cell.configure(with: viewModel, delegate: hostCellDelegate)
            return cell
        }
    }
}
