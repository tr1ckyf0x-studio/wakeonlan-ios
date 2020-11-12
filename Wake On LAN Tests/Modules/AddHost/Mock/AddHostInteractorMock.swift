//
//  AddHostInteractorMock.swift
//  Wake on LAN
//
//  Created by Владислав Лисянский on 01.11.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import Foundation
@testable import Wake_on_LAN

class AddHostInteractorMock {

    private(set) var didCallSaveForm = false
    private(set) var didCallUpdateForm = false

}

extension AddHostInteractorMock: AddHostInteractorInput {

    func saveForm(_ form: AddHostForm) {
        didCallSaveForm = true
    }

    func updateForm(_ form: AddHostForm) {
        didCallUpdateForm = true
    }

}
