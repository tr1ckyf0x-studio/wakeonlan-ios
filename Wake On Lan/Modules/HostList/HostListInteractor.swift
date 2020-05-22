//
//  HostListInteractor.swift
//  Wake on LAN
//
//  Created by Владислав Лисянский on 21.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import Foundation
import Resolver
import CoreData

class HostListInteractor: HostListInteractorInput {
    
    weak var presenter: HostListInteractorOutput?
    
    @Injected private var coreDataService: PersistentCoreDataService
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(contextDidSave(_:)), name: Notification.Name.NSManagedObjectContextDidSave, object: coreDataService.mainContext)
    }
    
    func fetchHosts() {
        do {
            let request = Host.fetchRequest() as NSFetchRequest<Host>
            let sort = NSSortDescriptor(keyPath: \Host.id, ascending: true)
            request.sortDescriptors = [sort]
            let hosts = try request.execute()
            presenter?.interactor(self, didUpdateHosts: hosts)
        } catch {
            // TODO: Обработка ошибок
        }
    }
    
    @objc func contextDidSave(_ notification: Notification) {
        fetchHosts()
    }
}
