//
//  UpdatesManagedObject.swift
//  Wake on LAN
//
//  Created by Dmitry Stavitsky on 07.12.2023.
//  Copyright © 2023 Vladislav Lisianskii. All rights reserved.
//

import CoreData

public protocol UpdatesManagedObject {
    associatedtype Model: Sendable
    associatedtype ManagedObject: NSManagedObject

    func update(from model: Model, in context: NSManagedObjectContext)
}
