//
//  HostListTableViewModel.swift
//  Wake on LAN
//
//  Created by Dmitry on 10.08.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import CoreDataService

final class HostListDataStore {

    // MARK: - Properties

    private(set) var sections = [HostListSectionModel]()

    // MARK: - Init

    init(sections: [HostListSectionModel] = []) {
        self.sections = sections
    }

    // MARK: - Public

    func insertObject(
        _ host: Host,
        at row: Int,
        in section: Int
    ) {
        var items = sections[section].items
        items.insert(.host(host), at: row)
        sections = [.mainSection(
            content: items,
            header: header(for: section),
            footer: footer(for: section)
        )]
    }

    func updateObject(
        _ host: Host,
        at row: Int,
        in section: Int
    ) {
        var items = sections[section].items
        items[row] = .host(host)
        sections = [.mainSection(
            content: items,
            header: header(for: section),
            footer: footer(for: section)
        )]
    }

    func removeObject(
        at index: Int,
        in section: Int
    ) {
        var items = sections[section].items
        items.remove(at: index)
        sections = [.mainSection(
                        content: items,
                        header: header(for: section),
                        footer: footer(for: section))]
    }

    func moveObject(
        from row: Int,
        to: Int,
        in section: Int
    ) {
        var items = sections[section].items
        let removedObject = items.remove(at: row)
        items.insert(removedObject, at: to)
        sections = [.mainSection(
            content: items,
            header: header(for: section),
            footer: footer(for: section)
        )]
    }

}

// MARK: - Private

private extension HostListDataStore {

    func header(for section: Int) -> String? {
        sections[section].header
    }

    func footer(for section: Int) -> String? {
        sections[section].footer
    }

}
