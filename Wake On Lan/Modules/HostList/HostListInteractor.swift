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
    @Injected private var wakeOnLanService: WakeOnLanService
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(contextDidSave(_:)), name: Notification.Name.NSManagedObjectContextDidSave, object: coreDataService.mainContext)
    }
    
    func fetchHosts() {
        coreDataService.mainContext.perform { [weak self] in
            guard let self = self else { return }
            do {
                let request = Host.fetchRequest() as NSFetchRequest<Host>
                let sort = NSSortDescriptor(keyPath: \Host.id, ascending: true)
                request.sortDescriptors = [sort]
                let hosts = try request.execute()
                self.presenter?.interactor(self, didUpdateHosts: hosts)
            } catch {
                print(error)
                // TODO: Обработка ошибок
            }
        }
    }
    
    func wakeHost(_ host: Host) {
        do {
            try wakeOnLanService.sendMagicPacket(to: host)
        } catch {
            presenter?.interactor(self, didEncounterError: error)
        }
    }
    
    @objc func contextDidSave(_ notification: Notification) {
        fetchHosts()
    }
}
