//
//  TextFormItem.swift
//  Wake on LAN
//
//  Created by Владислав Лисянский on 17.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import Foundation
import UIKit

enum AddHostFailureReason: String {
    // TODO: R.swift
    case invalidMACAddress = "Incorrect MAC address"
    case invalidIPAddress = "Incorrect IP address"
    case invalidPort = "Incorrect PORT"
    case unknown = "Unknown Error"
}

extension AddHostFailureReason: CustomStringConvertible {
    var description: String {
        return self.rawValue
    }
}

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
    var defaultValue: String?
    var failureReason: AddHostFailureReason = .unknown
    var keyboardType: UIKeyboardType = .asciiCapable
    
    var isMandatory: Bool = true
    
    var isValid: Bool {
        let defaultReplacedValue = value ?? defaultValue
        guard let validator = validator,
            let value = defaultReplacedValue
            else { return !isMandatory }
        
        return validator.validate(value: value)
    }
}
