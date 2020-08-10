//
//  HostListTableViewModel.swift
//  Wake on LAN
//
//  Created by Dmitry on 10.08.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import Foundation

struct HostListTableViewModel {

    private(set) var sections = [HostListSectionModel]()
    
    private func header(for section: Int) -> String? {
        return sections[section].header
    }
    
    private func footer(for section: Int) -> String? {
        return sections[section].footer
    }

    mutating func insertObject(_ host: Host, at row: Int, in section: Int) {
        var items = sections[section].items
        items.insert(.host(host), at: row)
        sections = [.mainSection(content: items,
                                 header: header(for: section),
                                 footer: footer(for: section))]
    }
    
    mutating func updateObject(_ host: Host, at row: Int, in section: Int) {
        var items = sections[section].items
        items[row] = .host(host)
        sections = [.mainSection(content: items,
                                 header: header(for: section),
                                 footer: footer(for: section))]
    }
    
    mutating func removeObject(at index: Int, in section: Int) {
        var items = sections[section].items
        items.remove(at: index)
        sections = [.mainSection(content: items,
                                 header: header(for: section),
                                 footer: footer(for: section))]
    }
    
    mutating func moveObject(from row: Int, to: Int, in section: Int) {
        var items = sections[section].items
        let removedObject = items.remove(at: row)
        items.insert(removedObject, at: to)
        sections = [.mainSection(content: items,
                                 header: header(for: section),
                                 footer: footer(for: section))]
    }

}
