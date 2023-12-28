//
//  ManagedObjectConvertible.swift
//  Wake on LAN
//
//  Created by Dmitry Stavitsky on 07.12.2023.
//  Copyright © 2023 Vladislav Lisianskii. All rights reserved.
//

import CoreData

public protocol ManagedObjectConvertible<Model, ManagedObject> {
    associatedtype Model
    associatedtype ManagedObject: NSManagedObject

    func toManagedObject(from model: Model, in context: NSManagedObjectContext) -> ManagedObject?
}
