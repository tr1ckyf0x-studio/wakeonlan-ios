//
//  FormValidable.swift
//  Wake on LAN
//
//  Created by Владислав Лисянский on 17.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import Foundation

protocol FormValidable {
    var isValid: Bool { get }
}

protocol FormMandatoryable {
    var isMandatory: Bool { get }
}
