//
//  AddHostPresenter.swift
//  Wake On Lan
//
//  Created by Vladislav Lisianskii on 27.04.2020.
//  Copyright © 2020 Vladislav Lisianskii. All rights reserved.
//

import WOLSharedProtocolsAndModels

@MainActor
final class AddHostPresenter: Navigates {
    // MARK: - Properties

    weak var view: AddHostViewInput?
    var interactor: AddHostInteractorInput?
    var router: AddHostRoutes?

    private(set) var tableManager = AddHostTableManager()
    private(set) var addHostForm: AddHostForm

    private var isSaving = false

    // MARK: - Init

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

        // NOTE: The save control stays enabled and nothing visible happens while the write is in
        // flight, so a second tap used to re-enter the create branch with a fresh child context —
        // inserting the host twice and colliding the `order` of every existing host.
        guard !isSaving else { return }
        isSaving = true

        if addHostForm.host == nil {
            // Host does not yet exists
            interactor?.saveForm(addHostForm)
        } else {
            // Host already exists
            interactor?.updateForm(addHostForm)
        }
    }

    func viewDidPressBackButton(_ view: AddHostViewInput) {
        navigate(to: router?.backOrDismiss(animated: true))
    }
}

// MARK: - AddHostInteractorOutput

extension AddHostPresenter: AddHostInteractorOutput {
    func interactor(_ interactor: AddHostInteractorInput, didSaveForm form: AddHostForm) {
        isSaving = false
        navigate(to: router?.backOrDismiss(animated: true))
    }

    func interactor(_ interactor: AddHostInteractorInput, didUpdateForm form: AddHostForm) {
        isSaving = false
        navigate(to: router?.backOrDismiss(animated: true))
    }
}

// MARK: - AddHostTableManagerDelegate

extension AddHostPresenter: AddHostTableManagerDelegate {
    func tableManagerDidTapDeviceIconCell(_ manager: AddHostTableManager, _ model: IconModel) {
        navigate(to: router?.openChooseIcon(with: self))
    }
}

// MARK: - ChooseIconModuleOutput

extension AddHostPresenter: ChooseIconModuleOutput {
    func chooseIconModuleDidSelectIcon(_ iconModel: IconModel) {
        addHostForm.iconModel = iconModel
        addHostForm.sections.forEach { section in
            guard
                case let .section(_, _, _, kind) = section,
                kind == .deviceIcon
            else {
                return
            }
            view?.reloadTable(with: section)
        }
    }
}
