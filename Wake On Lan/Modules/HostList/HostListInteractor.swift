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
import CocoaLumberjackSwift

final class HostListInteractor: HostListInteractorInput {

    @Injected private var coreDataService: CoreDataService

    @Injected private var wakeOnLanService: WakeOnLanService

    weak var presenter: HostListInteractorOutput?

    private lazy var cacheTracker: HostListCacheTracker<Host, HostListInteractor> = {
        DDLogVerbose("HostListCacheTracker initialized")
        return HostListCacheTracker(with: Host.sortedFetchRequest,
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
            DDLogDebug("Magic packet was sent")
        } catch {
            presenter?.interactor(self, didEncounterError: error)
            DDLogError("Magic packet was not sent due to error: \(error)")
        }
    }

    func deleteHost(_ host: Host) {
        guard let context = host.managedObjectContext else { return }
        context.perform { [weak self] in
            context.delete(host)
            self?.coreDataService.saveContext(context)
            DDLogDebug("Host deleted")
        }
    }

}

extension HostListInteractor: HostListCacheTrackerDelegate {

    typealias Object = Host

    func cacheTracker(_ tracker: CacheTracker,
                      didChangeContent content: [Content]) {
        DDLogDebug("CacheTracker changed content")
        presenter?.interactor(self, didChangeContent: content)
    }

}
