import Foundation

public protocol CoreDataMigration: AnyObject {
    func execute() async throws
}
