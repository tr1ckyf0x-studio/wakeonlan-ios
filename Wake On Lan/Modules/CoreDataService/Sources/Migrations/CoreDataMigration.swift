import Foundation

protocol CoreDataMigrationInternal: AnyObject {
    var coreDataService: (CoreDataServiceProtocol & CoreDataServiceInternalProtocol)? { get set }
}

public protocol CoreDataMigration: AnyObject {
    func execute() async throws
}
