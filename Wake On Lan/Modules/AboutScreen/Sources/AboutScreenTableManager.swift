//
//  AboutScreenTableManager.swift
//  AboutScreen
//
//  Created by Vladislav Lisianskii on 02.05.2021.
//  Copyright © 2021 Владислав Лисянский. All rights reserved.
//

import UIKit

public protocol ManagingAboutScreenTable: UITableViewDataSource, UITableViewDelegate {
    var rows: [MenuButtonCellViewModel] { get set }
}

public final class AboutScreenTableManager: NSObject, ManagingAboutScreenTable {
    public var rows: [MenuButtonCellViewModel] = []
}

// MARK: - UITableViewDataSource

extension AboutScreenTableManager: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = rows[indexPath.row]
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "\(MenuButtonTableCell.self)",
                for: indexPath
            ) as? MenuButtonTableCell
        else {
            return .init()
        }
        cell.configure(with: model)

        return cell
    }
}
