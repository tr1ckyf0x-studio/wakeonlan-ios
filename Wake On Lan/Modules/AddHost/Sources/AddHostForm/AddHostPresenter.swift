//
//  AddHostPresenter.swift
//  Wake On Lan
//
//  Created by Владислав Лисянский on 27.04.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import SharedModels

class AddHostPresenter<Router: AddHostRouterProtocol> {
    weak var view: AddHostViewInput?

    var interactor: AddHostInteractorInput?

    var router: Router?

    private(set) var tableManager = AddHostTableManager()

    private(set) var addHostForm: AddHostForm

    init(addHostForm: AddHostForm = AddHostForm()) {
        self.addHostForm = addHostForm
    }

}

// MARK: - AddHostViewOutput

extension AddHostPresenter: AddHostViewOutput {

    func viewDidLoad(_ view: AddHostViewInput) {
        tableManager.form = addHostForm
        tableManager.delegate = self
        view.reloadTable()
    }

    func viewDidPressSaveButton(_ view: AddHostViewInput) {
        // TODO: Обработка ошибок формы
        guard addHostForm.isValid else { return }

        if addHostForm.host == nil {
            // Host does not yet exists
            interactor?.saveForm(addHostForm)
        } else {
            // Host already exists
            interactor?.updateForm(addHostForm)
        }
    }

    func viewDidPressBackButton(_ view: AddHostViewInput) {
        router?.popCurrentController(animated: true)
    }

}

// MARK: - AddHostInteractorOutput

extension AddHostPresenter: AddHostInteractorOutput {
    func interactor(_ interactor: AddHostInteractorInput, didSaveForm form: AddHostForm) {
        router?.popCurrentController(animated: true)
    }

    func interactor(_ interactor: AddHostInteractorInput, didUpdateForm form: AddHostForm) {
        router?.popCurrentController(animated: true)
    }
}

// MARK: - AddHostTableManagerDelegate

extension AddHostPresenter: AddHostTableManagerDelegate {
    func tableManagerDidTapDeviceIconCell(_ manager: AddHostTableManager, _ model: IconModel) {
        router?.routeToChooseIcon()
    }
}

// MARK: - ChooseIconModuleOutput

extension AddHostPresenter: ChooseIconModuleOutput {
    func chooseIconModuleDidSelectIcon(_ iconModel: IconModel) {
        addHostForm.iconModel = iconModel
        // NOTE: We can use reloadTable without performance issues
        // because table consists only one section and row
        view?.reloadTable()
    }
}
