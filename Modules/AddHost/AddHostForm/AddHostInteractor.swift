//
//  AddHostInteractor.swift
//  Wake on LAN
//
//  Created by Владислав Лисянский on 20.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import CocoaLumberjack
import CoreDataService

final class AddHostInteractor: AddHostInteractorInput {

    weak var presenter: AddHostInteractorOutput?

    private let coreDataService: CoreDataServiceProtocol
    private let hostCrudWorker: PerformsHostCRUD

    init(
        coreDataService: CoreDataServiceProtocol,
        hostCrudWorker: PerformsHostCRUD
    ) {
        self.coreDataService = coreDataService
        self.hostCrudWorker = hostCrudWorker
    }

    func saveForm(_ form: AddHostForm) {
        hostCrudWorker.create(
            from: form,
            in: coreDataService.createChildConcurrentContext()
        ) { [weak self] _ in
            guard let self else { return }
            self.presenter?.interactor(self, didSaveForm: form)
            DDLogDebug("Host saved")
        }
    }

    func updateForm(_ form: AddHostForm) {
        guard let host = form.host else {
            DDLogWarn("Host does not exist in form")
            return
        }
        hostCrudWorker.update(
            host: host,
            in: coreDataService.createChildConcurrentContext(),
            with: form
        ) { [weak self] _ in
            guard let self else { return }
            self.presenter?.interactor(self, didUpdateForm: form)
            DDLogDebug("Host updated")
        }
    }

}
