//
//  TextFormItem.swift
//  Wake on LAN
//
//  Created by Владислав Лисянский on 17.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import SharedProtocols
import UIKit

final class TextFormItem: Validable, Mandatoryable {
    var value: String? {
        didSet {
            onValueChanged?(value)
        }
    }
    var placeholder: String = .empty
    var defaultValue: String?
    var formatted: String? {
        formatter.flatMap { $0.format(text: value ?? .empty) }
    }

    var indexPath: IndexPath?
    var onValueChanged: ((String?) -> Void)?

    var validator: TextValidator?
    var formatter: TextFormatter?

    var maxLength: Int?
    var isMandatory: Bool = true
    var needsUppercased: Bool = false
    var failureReason: AddHostForm.Error?
    var keyboardType: UIKeyboardType = .asciiCapable

    var isValid: Bool {
        let needsDefaultValue = [value == nil, value == .empty].contains { $0 == true }
        let defaultReplacedValue = needsDefaultValue ? defaultValue : value
        guard
            let validator = validator,
            let value = defaultReplacedValue
        else {
            return !isMandatory
        }

        return validator.validate(value: value)
    }

}
