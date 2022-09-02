import Foundation

public final class CoreDataMigrationController {
    private var migrations: [CoreDataMigration] = []
    private let coreDataService: CoreDataServiceProtocol

    public init(coreDataService: CoreDataServiceProtocol) {
        self.coreDataService = coreDataService
    }

    public func migration(_ migration: CoreDataMigration) -> Self {
        migrations.append(migration)
        (migration as? CoreDataMigrationInternal)?
            .coreDataService = coreDataService as? CoreDataServiceProtocol & CoreDataServiceInternalProtocol
        return self
    }

    public func performMigrations() async throws {
        for migration in migrations {
            try await migration.execute()
        }
    }
}
