//
//  AboutScreenTableManager.swift
//  AboutScreen
//
//  Created by Vladislav Lisianskii on 02.05.2021.
//  Copyright © 2021 Владислав Лисянский. All rights reserved.
//

import UIKit

public protocol ManagingAboutScreenTable: UITableViewDataSource, UITableViewDelegate {
    var sections: [AboutScreenSectionModel] { get set }
}

public final class AboutScreenTableManager: NSObject, ManagingAboutScreenTable {
    public var sections: [AboutScreenSectionModel] = []
}

// MARK: - UITableViewDataSource

extension AboutScreenTableManager: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].items.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = sections[indexPath.section].items[indexPath.row]

        var cell: UITableViewCell?

        switch model {
        case let .menuButton(menuButtonCellViewModel):
            let menuButtonCell = tableView.dequeueReusableCell(
                withIdentifier: "\(MenuButtonTableCell.self)",
                for: indexPath
            ) as? MenuButtonTableCell

            menuButtonCell?.configure(with: menuButtonCellViewModel)

            cell = menuButtonCell
        }

        guard let cell = cell else {
            fatalError("Cell was not initialized")
        }

        return cell
    }
}

// MARK: - UITableViewDelegate

extension AboutScreenTableManager: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let model = sections[section]

        var headerView: UIView?

        switch model {
        case let .mainSection(_, appName, appVersion):
            let view = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: "\(AboutHeaderTableView.self)"
            ) as? AboutHeaderTableView

            view?.configure(appName: appName, appVersion: appVersion)
            headerView = view
        }

        return headerView
    }
}
