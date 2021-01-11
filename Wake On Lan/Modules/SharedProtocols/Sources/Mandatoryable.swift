//
//  FormMandatoryable.swift
//  Wake on LAN
//
//  Created by Dmitry on 24.12.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import Foundation

public protocol Mandatoryable {
    var isMandatory: Bool { get }
}
