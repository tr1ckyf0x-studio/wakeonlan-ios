import Foundation

public protocol CoreDataMigration: AnyObject {
    /// Executes migration
    func execute() async throws
}
