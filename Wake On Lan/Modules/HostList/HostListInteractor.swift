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

final class HostListInteractor: HostListInteractorInput {

    @Injected private var coreDataService: PersistentCoreDataService

    @Injected private var wakeOnLanService: WakeOnLanService

    weak var presenter: HostListInteractorOutput?

    private lazy var cacheTracker: HostListCacheTracker<Host, HostListInteractor> = {
        HostListCacheTracker(with: Host.sortedFetchRequest,
                             context: coreDataService.mainContext,
                             delegate: self)
    }()

    func fetchHosts() {
        guard let hosts = cacheTracker.fetchedObjects else { return }
        presenter?.interactor(self, didFetchHosts: hosts)
    }

    func wakeHost(_ host: Host) {
        do {
            try wakeOnLanService.sendMagicPacket(to: host)
        } catch {
            presenter?.interactor(self, didEncounterError: error)
        }
    }

    func deleteHost(_ host: Host) {
        let context = coreDataService.createChildConcurrentContext()
        let object = context.object(with: host.objectID)
        context.delete(object)
        coreDataService.saveContext(context)
    }
}

extension HostListInteractor: HostListCacheTrackerDelegate {

    typealias Object = Host

    func cacheTracker(_ tracker: CacheTracker,
                      didChangeContent content: [Content]) {
        presenter?.interactor(self, didChangeContent: content)
    }

}
