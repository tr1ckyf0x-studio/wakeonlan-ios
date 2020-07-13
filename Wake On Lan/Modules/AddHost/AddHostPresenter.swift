//
//  AddHostPresenter.swift
//  Wake On Lan
//
//  Created by Владислав Лисянский on 27.04.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import Foundation

class AddHostPresenter {
    weak var view: AddHostViewInput?
    
    var interactor: AddHostInteractorInput?
    
    var router: AddHostRouter?
    
    private(set) var tableManager = AddHostTableManager()
    
    private(set) var addHostForm: AddHostForm
    
    init(addHostForm: AddHostForm = AddHostForm()) {
        self.addHostForm = addHostForm
    }

}

extension AddHostPresenter: AddHostViewOutput {
    
    func viewDidLoad(_ view: AddHostViewInput) {
        tableManager.form = addHostForm
        tableManager.delegate = self

        view.reloadTable()
    }

    func viewDidPressSaveButton(_ view: AddHostViewInput) {
        // TODO: Обработка ошибок формы
        guard addHostForm.isValid else { return }
        interactor?.saveForm(addHostForm)
    }
    
    func viewDidPressBackButton(_ view: AddHostViewInput) {
        router?.popCurrentController(animated: true)
    }

}

extension AddHostPresenter: AddHostInteractorOutput {
    func interactor(_ interactor: AddHostInteractorInput, didSaveForm form: AddHostForm) {
        router?.popCurrentController(animated: true)
    }
}

extension AddHostPresenter: AddHostTableManagerDelegate {
    func tableManagerDidTapDeviceIconCell(_ manager: AddHostTableManager, _ model: IconModel) {
        router?.routeToChooseIcon(items: addHostForm.iconSectionItems)
    }
}

extension AddHostPresenter: ChooseIconModuleOutput {
    func chooseIconModuleDidSelectIcon(_ iconModel: IconModel) {
        addHostForm.iconModel = iconModel
        view?.reloadTable()
    }

}
