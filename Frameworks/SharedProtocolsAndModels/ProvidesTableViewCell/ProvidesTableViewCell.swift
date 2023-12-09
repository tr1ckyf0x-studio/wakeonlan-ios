//
//  ProvidesTableViewCell.swift
//  AboutScreen
//
//  Created by Vladislav Lisianskii on 21.11.2023.
//

import UIKit

public protocol ProvidesTableViewCell<ItemIdentifierType> {
    associatedtype ItemIdentifierType: Hashable, Sendable

    func makeTableViewCell(
        _ tableView: UITableView,
        _ indexPath: IndexPath,
        _ itemIdentifier: ItemIdentifierType
    ) -> UITableViewCell?
}
