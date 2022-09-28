//
//  AddHostInteractor.swift
//  Wake on LAN
//
//  Created by Владислав Лисянский on 20.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import Resolver
import CoreDataService
import CocoaLumberjackSwift

final class AddHostInteractor: AddHostInteractorInput {

    weak var presenter: AddHostInteractorOutput?

    @Injected var coreDataService: CoreDataServiceProtocol

    func saveForm(_ form: AddHostForm) {
        let context = coreDataService.createChildConcurrentContext()
        Host.insert(into: context, form: form)
        coreDataService.saveContext(context) { [weak self] in
            guard let self else { return }
            self.presenter?.interactor(self, didSaveForm: form)
            DDLogDebug("Host saved")
        }
    }

    func updateForm(_ form: AddHostForm) {
        let context = coreDataService.createChildConcurrentContext()
        context.perform { [weak self] in
            guard let host = form.host else {
                DDLogWarn("Host does not exist in form")
                return
            }
            Host.update(object: host, into: context, with: form)
            self?.coreDataService.saveContext(context) { [weak self] in
                guard let self else { return }
                self.presenter?.interactor(self, didUpdateForm: form)
                DDLogDebug("Host updated")
            }
        }
    }

}
