//
//  DonateScreenTableSection.swift
//  
//
//  Created by Vladislav Lisianskii on 15.04.2023.
//

import Foundation

enum DonateScreenTableSectionItem: Equatable, Hashable {
    case purchase(_ purchase: ProductViewModel)
}

enum DonateScreenTableSectionModel: Equatable, Hashable {
    typealias Item = DonateScreenTableSectionItem

    case donateSection(content: [Item], footer: String)
}

extension DonateScreenTableSectionModel {
    var content: [Item] {
        switch self {
        case let .donateSection(content, _):
            return content
        }
    }

    var footer: String? {
        switch self {
        case let .donateSection(_, footer):
            return footer
        }
    }
}
