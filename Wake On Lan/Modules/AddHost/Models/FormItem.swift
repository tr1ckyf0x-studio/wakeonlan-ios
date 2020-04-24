//
//  FormItem.swift
//  Wake on LAN
//
//  Created by Владислав Лисянский on 17.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import Foundation

enum FormItem {
    case text(_ formItem: TextFormItem)
}

extension FormItem: FormValidable {
    var isValid: Bool {
        switch self {
        case let .text(formItem): return formItem.isValid
        }
    }
    
    var isMandatory: Bool {
        get {
            switch self {
            case let .text(formItem): return formItem.isMandatory
            }
        }
        set {
            switch self {
            case let .text(formItem): formItem.isMandatory = newValue
            }
        }
    }
    
}
