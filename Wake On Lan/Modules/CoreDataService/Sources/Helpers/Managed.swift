//
//  Managed.swift
//  Wake on LAN
//
//  Created by Dmitry on 26.06.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import CoreData
import Foundation

public protocol Managed: AnyObject, NSFetchRequestResult {
    static var entityName: String { get }
    static var sortedFetchRequest: NSFetchRequest<Self> { get }
    static var defaultSortDescriptors: [NSSortDescriptor] { get }
}

public extension Managed {
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
            fatalError("Name for entity \(self) does not assigned!")
        }
        return name
    }

}
