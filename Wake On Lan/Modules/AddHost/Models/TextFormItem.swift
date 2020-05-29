//
//  TextFormItem.swift
//  Wake on LAN
//
//  Created by Владислав Лисянский on 17.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit

class TextFormItem: FormValidable {
    var value: String? {
        didSet {
            onValueChanged?(value)
        }
    }
    var placeholder = ""
    var indexPath: IndexPath?
    var onValueChanged: ((String?) -> Void)?
    var validator: TextValidator?
    var formatter: TextFormatter?
    var defaultValue: String?
    var failureReason: AddHostForm.Error?
    var keyboardType: UIKeyboardType = .asciiCapable
    var isMandatory: Bool = true
    var maxLength: Int?
    var needsUppercased: Bool = false
    
    var isValid: Bool {
        let defaultReplacedValue = value ?? defaultValue
        guard let validator = validator,
            let value = defaultReplacedValue
            else { return !isMandatory }
        
        return validator.validate(value: value)
    }

    var formatted: String? {
        guard let formatter = self.formatter else {
            return value
        }
        return formatter.format(text: value ?? "")
    }

}
