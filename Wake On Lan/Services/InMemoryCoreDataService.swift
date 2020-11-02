//
//  InMemoryCoreDataService.swift
//  Wake on LAN
//
//  Created by Владислав Лисянский on 02.11.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import Foundation
import CoreData
import CocoaLumberjackSwift

final class InMemoryCoreDataService: CoreDataService {

    lazy var persistentContainer: NSPersistentContainer = {
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType

        let container = NSPersistentContainer(name: "HostsDataModel")

        container.persistentStoreDescriptions = [persistentStoreDescription]

        return container
    }()

}
