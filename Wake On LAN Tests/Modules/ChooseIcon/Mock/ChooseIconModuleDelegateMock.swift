//
//  ChooseIconModuleDelegateMock.swift
//  WakeOnLanTests
//
//  Created by Владислав Лисянский on 01.11.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import Foundation
@testable import Wake_on_LAN

class ChooseIconModuleDelegateMock {
    private(set) var didCallChooseIconModuleDidSelectIcon = false
    private(set) var setIconModel: IconModel?
}

extension ChooseIconModuleDelegateMock: ChooseIconModuleOutput {
    func chooseIconModuleDidSelectIcon(_ iconModel: IconModel) {
        self.setIconModel = iconModel
        didCallChooseIconModuleDidSelectIcon = true
    }
}
