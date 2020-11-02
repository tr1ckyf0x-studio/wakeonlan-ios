//
//  PersistentCoreDataService.swift
//  Wake on LAN
//
//  Created by Владислав Лисянский on 20.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import Foundation
import CoreData
import CocoaLumberjackSwift

final class PersistentCoreDataService: CoreDataService {

    lazy var persistentContainer = NSPersistentContainer(name: "HostsDataModel")

}
