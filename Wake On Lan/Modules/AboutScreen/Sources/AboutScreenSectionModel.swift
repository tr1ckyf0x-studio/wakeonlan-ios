//
//  File.swift
//  
//
//  Created by Vladislav Lisianskii on 06.08.2021.
//

import Foundation

public enum AboutScreenSectionItem {
    case menuButton(MenuButtonCellViewModel)
}

public enum AboutScreenSectionModel {

    public typealias Item = AboutScreenSectionItem

    case mainSection(content: [Item], appName: String, appVersion: String?, build: String?)

    var items: [Item] {
        switch self {
        case let .mainSection(content, _, _, _): return content
        }
    }
}
