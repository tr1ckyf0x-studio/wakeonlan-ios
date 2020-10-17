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
    case icon(_ iconModel: IconModel)
}

extension FormItem: FormValidable, FormMandatoryable {
    var isValid: Bool {
        switch self {
        case let .text(formItem):
            return formItem.isValid

        default:
            return true
        }
    }

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
