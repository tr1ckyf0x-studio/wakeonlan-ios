//
//  FormSection.swift
//  Wake on LAN
//
//  Created by Владислав Лисянский on 17.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import SharedProtocolsAndModels

enum FormSection {

    case section(content: [Item], header: FormSectionHeader? = nil, footer: FormSectionFooter? = nil, kind: Kind? = nil)

    // MARK: - Kind

    enum Kind: Int {
        case deviceIcon
        case title
        case macAddress
        case destination
        case port
    }

    // MARK: - FormSectionHeader

    struct FormSectionHeader: Mandatoryable {
        let header: String
        let isMandatory: Bool

        init(header: String, mandatory: Bool = true) {
            self.header = header
            self.isMandatory = mandatory
        }

    }

    // MARK: - FormSectionFooter

    struct FormSectionFooter: Mandatoryable {
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
    typealias Header = FormSectionHeader
    typealias Footer = FormSectionFooter
    typealias KindType = Kind?

    var items: [Item] {
        switch self {
        case let .section(content, _, _, _):
            return content
        }
    }

    var header: FormSectionHeader? {
        switch self {
        case let .section(_, header, _, _):
            return header
        }
    }

    var footer: FormSectionFooter? {
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
