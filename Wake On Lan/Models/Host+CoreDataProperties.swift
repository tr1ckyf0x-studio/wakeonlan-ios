//
//  Host+CoreDataProperties.swift
//  
//
//  Created by Владислав Лисянский on 20.05.2020.
//
//

import Foundation
import CoreData


extension Host {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Host> {
        return NSFetchRequest<Host>(entityName: "Host")
    }

    @NSManaged public var title: String
    @NSManaged public var iconName: String
    @NSManaged public var macAddress: String
    @NSManaged public var ipAddress: String?
    @NSManaged public var port: String?
    @NSManaged public var id: UUID

}
