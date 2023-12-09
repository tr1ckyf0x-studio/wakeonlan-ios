//
//  PerformsMoveOperation.swift
//  Wake on LAN
//
//  Created by Dmitry Stavitsky on 07.12.2023.
//  Copyright © 2023 Владислав Лисянский. All rights reserved.
//

import CoreData

public protocol PerformsMoveOperation<CoreDataObject> {
    associatedtype CoreDataObject: NSManagedObject

    func move(
        from sourceIndexPath: IndexPath,
        to destinationIndexPath: IndexPath,
        among fetchedObjects: inout [CoreDataObject],
        context: NSManagedObjectContext
    )
}
