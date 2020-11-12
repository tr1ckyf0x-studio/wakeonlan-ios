//
//  AddHostPresenterMock.swift
//  WakeOnLanTests
//
//  Created by Владислав Лисянский on 01.11.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import Foundation
@testable import Wake_on_LAN

class AddHostPresenterMock {

    let tableManager = AddHostTableManager()

    private(set) var interactorDidSaveForm = false
    private(set) var interactorDidUpdateForm = false
    private(set) var didCallViewDidLoad = false
    private(set) var didCallViewDidPressSaveButton = false
    private(set) var didCallViewDidPressBackButton = false

}

extension AddHostPresenterMock: AddHostInteractorOutput {
    func interactor(_ interactor: AddHostInteractorInput, didSaveForm form: AddHostForm) {
        interactorDidSaveForm = true
    }

    func interactor(_ interactor: AddHostInteractorInput, didUpdateForm form: AddHostForm) {
        interactorDidUpdateForm = true
    }
}

extension AddHostPresenterMock: AddHostViewOutput {
    func viewDidLoad(_ view: AddHostViewInput) {
        didCallViewDidLoad = true
    }

    func viewDidPressSaveButton(_ view: AddHostViewInput) {
        didCallViewDidPressSaveButton = true
    }

    func viewDidPressBackButton(_ view: AddHostViewInput) {
        didCallViewDidPressBackButton = true
    }
}
