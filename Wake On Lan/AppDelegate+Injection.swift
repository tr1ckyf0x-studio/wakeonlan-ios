//
//  AppDelegate+Injection.swift
//  Wake on LAN
//
//  Created by Владислав Лисянский on 21.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import CoreDataService
import Resolver
import WakeOnLanService

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        register { WakeOnLanService() }.scope(.application)
        register(CoreDataServiceProtocol.self) { CoreDataService<SQLite>() }.scope(.application)
    }
}

private extension Resolver {
    typealias SQLite = PersistentContainer.SQLite
    typealias InMemory = PersistentContainer.InMemory
}
