//
//  FormSection.swift
//  Wake on LAN
//
//  Created by Владислав Лисянский on 17.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import Foundation

struct FormSectionHeader: FormMandatoryable {
    let header: String
    let isMandatory: Bool

    init(header: String, mandatory: Bool = true) {
        self.header = header
        self.isMandatory = mandatory
    }

}

struct FormSectionFooter: FormMandatoryable {
    let footer: String
    let isMandatory: Bool

    init(footer: String, mandatory: Bool = true) {
        self.footer = footer
        self.isMandatory = mandatory
    }

}

enum FormSection {

    enum Kind {
        case deviceIcon
        case title
        case macAddress
        case ipAddress
        case port
    }

    typealias Item = FormItem
    
    case section(content: [Item],
        header: FormSectionHeader?,
        footer: FormSectionFooter?,
        kind: FormSection.Kind? = nil)
    
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

    var kind: FormSection.Kind? {
        switch self {
        case let .section(_, _, _, kind):
            return kind
        }
    }

}
