//
//  Form.swift
//  Wake on LAN
//
//  Created by Владислав Лисянский on 17.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import Foundation

protocol FormRepresentable {
    var formSections: [FormSection] { get }
    var isValid: Bool { get }
}
