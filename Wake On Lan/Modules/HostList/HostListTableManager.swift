//
//  HostListTableManager.swift
//  Wake on LAN
//
//  Created by Владислав Лисянский on 21.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit

protocol HostListTableManagerDelegate: class {
    func tableManager(_ tableManager: HostListTableManager, didSelectRowAt indexPath: IndexPath)
    func tableManagerDidTapInfoButton(_ tableManager: HostListTableManager, host: Host)
}

class HostListTableManager: NSObject {

    var sections = [HostListSectionModel]()

    weak var delegate: HostListTableManagerDelegate?

}

extension HostListTableManager: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        let model = sections[indexPath.section].items[indexPath.row]
        switch model {
        case let .host(host):
            let hostCell = tableView.dequeueReusableCell(
                withIdentifier: "\(HostListTableViewCell.self)",
                for: indexPath) as? HostListTableViewCell
            hostCell?.configure(with: host, didTapInfoBlock: { [unowned self] _ in
                self.delegate?.tableManagerDidTapInfoButton(self, host: host)
            })
            cell = hostCell
        }
        
        guard let unwrappedCell = cell else { fatalError("Unknown cell identifier") }
        
        return unwrappedCell
    }

}

extension HostListTableManager: UITableViewDelegate {

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].header
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return sections[section].footer
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.tableManager(self, didSelectRowAt: indexPath)
    }
}
