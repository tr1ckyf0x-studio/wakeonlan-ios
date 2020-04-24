//
//  FormSection.swift
//  Wake on LAN
//
//  Created by Владислав Лисянский on 17.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import Foundation

enum FormSection {
    typealias Item = FormItem
    
    case section(content: [Item], header: String?, footer: String?)
    
    var items: [Item] {
        switch self {
        case let .section(content, _, _): return content
        }
    }
    
    var header: String? {
        switch self {
        case let .section(_, header, _): return header
        }
    }
    
    var footer: String? {
        switch self {
        case let .section(_, _, footer): return footer
        }
    }
}
