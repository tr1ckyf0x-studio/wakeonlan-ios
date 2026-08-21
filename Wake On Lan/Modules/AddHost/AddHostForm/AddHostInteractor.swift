//
//  AddHostInteractor.swift
//  Wake on LAN
//
//  Created by Vladislav Lisianskii on 20.05.2020.
//  Copyright © 2020 Vladislav Lisianskii. All rights reserved.
//

import CocoaLumberjackSwift
import CoreDataService
import PersistenceCore
import WOLSharedProtocolsAndModels

final class AddHostInteractor: AddHostInteractorInput {
    typealias CRUDPerformer = any PerformsCRUDOperation<any AddHostFormRepresentable, Host>

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
        let context = coreDataService.mainContext.createChildContext(kind: .concurrent)
        hostCrudWorker.create(from: form, in: context) { [weak self] _ in
            guard let self else { return }
            presenter?.interactor(self, didSaveForm: form)
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
        let context = coreDataService.mainContext.createChildContext(kind: .concurrent)
        hostCrudWorker.update(object: host, in: context, with: form) { [weak self] _ in
            guard let self else { return }
            presenter?.interactor(self, didUpdateForm: form)
            DDLogDebug("Host updated")
        }
    }
}
