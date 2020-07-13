//
//  IconSection.swift
//  Wake on LAN
//
//  Created by Dmitry Stavitsky on 28.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit

class IconModel {
    var pictureName: String
    var selected: Bool = false

    init(pictureName: String = R.image.other.name, selected: Bool) {
        self.pictureName = pictureName
        self.selected = selected
    }

}

// MARK: - Equatable
extension IconModel: Equatable {
    static func == (lhs: IconModel, rhs: IconModel) -> Bool {
        return lhs.pictureName == rhs.pictureName
    }
}

// MARK: - CustomStringConvertible
extension IconModel: CustomStringConvertible {
    var description: String {
         return "( \(self) : \(pictureName), \(selected) )"
     }
}

enum ChooseIconSectionItem {
    case icon(_ model: IconModel)
}

enum ChooseIconSection {

    typealias Item = FormItem

    case section(header: String? = nil, content: [Item], footer: String? = nil)

    var header: String? {
        switch self {
        case .section(let header, _, _):
            return header
        }
    }

    var content: [Item] {
        switch self {
        case .section(_, let content, _):
            return content
        }
    }

    var footer: String? {
        switch self {
        case .section(_, _, let footer):
            return footer
        }
    }

}
