//
//  AddHostViewControllerMock.swift
//  WakeOnLanTests
//
//  Created by Владислав Лисянский on 01.11.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import Foundation
@testable import Wake_on_LAN

class AddHostViewControllerMock {

    private(set) var didCallReloadTable = false

}

extension AddHostViewControllerMock: AddHostViewInput {

    func reloadTable() {
        didCallReloadTable = true
    }

}
