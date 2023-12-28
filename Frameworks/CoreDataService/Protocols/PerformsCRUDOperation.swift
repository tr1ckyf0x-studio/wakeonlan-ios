//
//  PerformsCRUDOperation.swift
//  Wake on LAN
//
//  Created by Dmitry Stavitsky on 07.12.2023.
//  Copyright © 2023 Vladislav Lisianskii. All rights reserved.
//

import CoreData

public protocol PerformsCRUDOperation<Model, ManagedObject> {
    typealias CompletionHandler = (Result<Void, Error>) -> Void

    associatedtype Model
    associatedtype ManagedObject: NSManagedObject

    func create(
        from model: Model,
        in context: NSManagedObjectContext,
        completion: CompletionHandler?
    )

    func update(
        object: ManagedObject,
        in context: NSManagedObjectContext,
        with model: Model,
        completion: CompletionHandler?
    )

    func delete(object: ManagedObject, in context: NSManagedObjectContext)
}
