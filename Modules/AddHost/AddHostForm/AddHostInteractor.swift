//
//  AddHostInteractor.swift
//  Wake on LAN
//
//  Created by Vladislav Lisianskii on 20.05.2020.
//  Copyright © 2020 Vladislav Lisianskii. All rights reserved.
//

import CocoaLumberjack
import CoreDataService
import SharedProtocolsAndModels

final class AddHostInteractor: AddHostInteractorInput {

    typealias CRUDPerformer = any PerformsCRUDOperation<AddHostFormRepresentable, Host>

    // MARK: - Properties

    weak var presenter: AddHostInteractorOutput?

    private let coreDataService: CoreDataServiceProtocol
    private let hostCrudWorker: CRUDPerformer

    // MARK: - Init

    init(
        coreDataService: CoreDataServiceProtocol,
        hostCrudWorker: CRUDPerformer
    ) {
        self.coreDataService = coreDataService
        self.hostCrudWorker = hostCrudWorker
    }

    // MARK: - AddHostInteractorInput

    func saveForm(_ form: AddHostForm) {
        let context = coreDataService.createChildConcurrentContext()
        hostCrudWorker.create(from: form, in: context) { [weak self] _ in
            guard let self else { return }
            self.presenter?.interactor(self, didSaveForm: form)
            DDLogDebug("Host saved")
        }
    }

    func updateForm(_ form: AddHostForm) {
        guard
            let host = form.host
        else {
            DDLogWarn("Host does not exist in form")
            return
        }
        let context = coreDataService.createChildConcurrentContext()
        hostCrudWorker.update(object: host, in: context, with: form) { [weak self] _ in
            guard let self else { return }
            self.presenter?.interactor(self, didUpdateForm: form)
            DDLogDebug("Host updated")
        }
    }
}
