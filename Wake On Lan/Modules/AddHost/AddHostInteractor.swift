//
//  AddHostInteractor.swift
//  Wake on LAN
//
//  Created by Владислав Лисянский on 20.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import Foundation
import Resolver
import CoreData

class AddHostInteractor: AddHostInteractorInput {

    weak var presenter: AddHostInteractorOutput?

    @Injected var coreDataService: PersistentCoreDataService

    func saveForm(_ form: AddHostForm) {
        let context = coreDataService.createChildConcurrentContext()
        Host.insert(into: context, form: form)
        coreDataService.saveContext(context) { [weak self] in
            guard let self = self else { return }
            self.presenter?.interactor(self, didSaveForm: form)
        }
    }

    func updateForm(_ form: AddHostForm) {
        let context = coreDataService.createChildConcurrentContext()
        context.perform { [unowned self] in
            Host.update(object: form.host!, into: context, with: form)
            self.coreDataService.saveContext(context) { [unowned self] in
                self.presenter?.interactor(self, didUpdateForm: form)
            }
        }
    }

}
