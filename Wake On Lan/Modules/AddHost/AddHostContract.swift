//
//  AddHostContract.swift
//  Wake On Lan
//
//  Created by Владислав Лисянский on 27.04.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import Foundation
import SharedProtocols

protocol AddHostViewOutput: class {
    var tableManager: AddHostTableManager { get }

    func viewDidLoad(_ view: AddHostViewInput)
    func viewDidPressSaveButton(_ view: AddHostViewInput)
    func viewDidPressBackButton(_ view: AddHostViewInput)
}

protocol AddHostViewInput: class {
    func reloadTable()
}

protocol AddHostInteractorInput: class {
    func saveForm(_ form: AddHostForm)
    func updateForm(_ form: AddHostForm)
}

protocol AddHostInteractorOutput: class {
    func interactor(_ interactor: AddHostInteractorInput, didSaveForm form: AddHostForm)
    func interactor(_ interactor: AddHostInteractorInput, didUpdateForm form: AddHostForm)
}

protocol AddHostRouterProtocol: class, Router {
    func routeToChooseIcon()
}
