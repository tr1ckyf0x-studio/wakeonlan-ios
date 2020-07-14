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
        context.performAndWait {
            let host = Host(context: context)
            guard let macAddress = form.macAddress,
                let title = form.title,
                let iconName = form.iconModel?.pictureName
                else { return }
            host.iconName = iconName
            host.title = title
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

    func updateForm(_ form: AddHostForm) {
        guard let currentHostUUID = form.host?.id,
            let macAddress = form.macAddress,
            let title = form.title,
            let iconName = form.iconModel?.pictureName else { return }
        let fetchRequest = Host.fetchRequest() as NSFetchRequest<Host>
        fetchRequest.predicate = NSPredicate(format: "id = %@", currentHostUUID.uuidString)
        let managedContext = coreDataService.createChildConcurrentContext()
        managedContext.performAndWait {
            do {
                let objects = try fetchRequest.execute()
                let updateObject = objects.first
                updateObject?.iconName = iconName
                updateObject?.title = title
                updateObject?.macAddress = macAddress
                if let ipAddress = form.ipAddress {
                    updateObject?.ipAddress = ipAddress
                }
                if let port = form.port {
                    updateObject?.port = port
                }
            } catch {
                print(error)
            }
        }
        coreDataService.saveContext(managedContext)
        presenter?.interactor(self, didUpdateForm: form)
    }

}
