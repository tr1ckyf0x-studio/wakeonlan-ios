//
//  AddHostContract.swift
//  Wake On Lan
//
//  Created by Vladislav Lisianskii on 27.04.2020.
//  Copyright © 2020 Vladislav Lisianskii. All rights reserved.
//

import SharedProtocolsAndModels
import SharedRouter

protocol AddHostViewOutput: AnyObject {
    var tableManager: AddHostTableManager { get }

    func viewDidLoad(_ view: AddHostViewInput)
    func viewDidPressSaveButton(_ view: AddHostViewInput)
    func viewDidPressBackButton(_ view: AddHostViewInput)
}

protocol AddHostViewInput: AnyObject {
    func reloadTable()
    func reloadTable(with section: FormSection)
}

protocol AddHostInteractorInput: AnyObject {
    func saveForm(_ form: AddHostForm)
    func updateForm(_ form: AddHostForm)
}

protocol AddHostInteractorOutput: AnyObject {
    func interactor(_ interactor: AddHostInteractorInput, didSaveForm form: AddHostForm)
    func interactor(_ interactor: AddHostInteractorInput, didUpdateForm form: AddHostForm)
}
