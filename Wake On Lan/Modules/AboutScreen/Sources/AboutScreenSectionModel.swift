//
//  AboutScreenSectionModel.swift
//  AboutScreen
//
//  Created by Vladislav Lisianskii on 02.05.2021.
//  Copyright © 2021 Владислав Лисянский. All rights reserved.
//

import Foundation

enum AboutScreenSectionItem {
    case header(appName: String, appVersion: String?)
    case menuButton(title: String, action: () -> Void)
}

enum AboutScreenSectionModel {

    typealias Item = AboutScreenSectionItem

    case mainSection(content: [Item], header: String? = nil, footer: String? = nil)

    var items: [Item] {
        switch self {
        case let .mainSection(content, _, _):
            return content
        }
    }

    var header: String? {
        switch self {
        case let .mainSection(_, header, _):
            return header
        }
    }

    var footer: String? {
        switch self {
        case let .mainSection(_, _, footer):
            return footer
        }
    }

}
