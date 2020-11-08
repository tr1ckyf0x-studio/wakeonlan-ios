//
//  GlobalServices+Injection.swift
//  Wake on LAN
//
//  Created by Владислав Лисянский on 21.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import Foundation
import Resolver

extension Resolver {
    public static func registerGlobalServices() {
        register( CoreDataServiceProtocol.self ) { CoreDataService<SQLite>() }.scope(application)
        register { WakeOnLanService() }.scope(application)
    }
}

private extension Resolver {
    typealias SQLite = PersistentContainer.SQLite
    typealias InMemory = PersistentContainer.InMemory
}
