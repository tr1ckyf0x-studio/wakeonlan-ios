//
//  FormSection.swift
//  Wake on LAN
//
//  Created by Владислав Лисянский on 17.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import SharedProtocolsAndModels

enum FormSection {

    case section(content: [Item], header: Header? = nil, footer: Footer? = nil, kind: Kind? = nil)

    // MARK: - Kind

    enum Kind: Int {
        case deviceIcon
        case title
        case macAddress
        case destination
        case port
    }

    // MARK: - Header

    struct Header: Mandatoryable {
        let header: String
        let isMandatory: Bool

        init(header: String, mandatory: Bool = true) {
            self.header = header
            self.isMandatory = mandatory
        }

    }

    // MARK: - Footer

    struct Footer: Mandatoryable {
        let footer: String
        let isMandatory: Bool

        init(footer: String, mandatory: Bool = true) {
            self.footer = footer
            self.isMandatory = mandatory
        }

    }
}

// MARK: - AddHostFormSectionRepresentable

extension FormSection: AddHostFormSectionRepresentable {
    typealias Item = FormItem

    var items: [Item] {
        switch self {
        case let .section(content, _, _, _):
            return content
        }
    }

    var header: Header? {
        switch self {
        case let .section(_, header, _, _):
            return header
        }
    }

    var footer: Footer? {
        switch self {
        case let .section(_, _, footer, _):
            return footer
        }
    }

    var kind: Kind? {
        switch self {
        case let .section(_, _, _, kind):
            return kind
        }
    }
}
