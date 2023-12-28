//
//  Managed.swift
//  Wake on LAN
//
//  Created by Dmitry on 26.06.2020.
//  Copyright © 2020 Vladislav Lisianskii. All rights reserved.
//

import CoreData

public protocol Managed: NSFetchRequestResult {
    static var entityName: String { get }
    static var sortedFetchRequest: NSFetchRequest<Self> { get }
    static var defaultSortDescriptors: [NSSortDescriptor] { get }
}

public extension Managed where Self: NSManagedObject {
    // TODO: Implement it
    static var defaultSortDescriptors: [NSSortDescriptor] { [] }

    static var sortedFetchRequest: NSFetchRequest<Self> {
        let request = NSFetchRequest<Self>(entityName: entityName)
        request.sortDescriptors = defaultSortDescriptors
        return request
    }
}

public extension Managed where Self: NSManagedObject {
    static var entityName: String {
        guard let name = entity().name else {
            fatalError("Name for entity \(self) is not assigned!")
        }
        return name
    }
}
