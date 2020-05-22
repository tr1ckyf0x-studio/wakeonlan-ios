//
//  AddHostInteractor.swift
//  Wake on LAN
//
//  Created by Владислав Лисянский on 20.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import Foundation
import Resolver

class AddHostInteractor: AddHostInteractorInput {
    weak var presenter: AddHostInteractorOutput?
    
    @Injected var coreDataService: PersistentCoreDataService
    
    func saveForm(_ form: AddHostForm) {
        let context = coreDataService.createChildConcurrentContext()
        context.performAndWait {
            let host = Host(context: context)
            guard let macAddress = form.macAddress else { return }
            host.macAddress = macAddress
            host.ipAddress = form.ipAddress
            host.port = form.port
            host.id = UUID()
        }
        coreDataService.saveContext(context) { [weak self] in
            guard let self = self else { return }
            self.presenter?.interactor(self, didSaveForm: form)
        }
    }
}
