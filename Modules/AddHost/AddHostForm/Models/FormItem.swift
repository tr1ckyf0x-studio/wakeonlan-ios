//
//  FormItem.swift
//  Wake on LAN
//
//  Created by Vladislav Lisianskii on 17.05.2020.
//  Copyright © 2020 Vladislav Lisianskii. All rights reserved.
//

import SharedProtocolsAndModels

enum FormItem {
    case text(_ formItem: TextFormItem)
    case icon(_ iconModel: IconModel)
}

// MARK: - Validable

extension FormItem: Validable {
    var isValid: Bool {
        switch self {
        case let .text(formItem):
            return formItem.isValid

        default:
            return true
        }
    }
}

// MARK: - Mandatoryable

extension FormItem: Mandatoryable {
    var isMandatory: Bool {
        get {
            switch self {
            case let .text(formItem):
                return formItem.isMandatory

            default:
                return true
            }
        }
        set {
            switch self {
            case let .text(formItem):
                formItem.isMandatory = newValue

            default:
                return
            }
        }
    }
}
