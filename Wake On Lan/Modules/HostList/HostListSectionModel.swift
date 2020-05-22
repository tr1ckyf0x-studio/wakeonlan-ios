//
//  HostListSectionModel.swift
//  Wake on LAN
//
//  Created by Владислав Лисянский on 21.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import Foundation

enum HostListSectionItem {
    case host(Host)
}

enum HostListSectionModel {
    typealias Item = HostListSectionItem
    
    case mainSection(content: [Item], header: String?, footer: String?)
    
    var items: [Item] {
        switch self {
        case let .mainSection(content, _, _): return content
        }
    }
    
    var header: String? {
        switch self {
        case let .mainSection(_, header, _): return header
        }
    }
    
    var footer: String? {
        switch self {
        case let .mainSection(_, _, footer): return footer
        }
    }
}
