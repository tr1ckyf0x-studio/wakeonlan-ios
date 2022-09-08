import Foundation

public final class CoreDataMigrationQueue {
    private var migrations: [CoreDataMigration] = []

    public init() { }

    public func migration(_ migration: CoreDataMigration) -> Self {
        migrations.append(migration)
        return self
    }

    public func performMigrations() async throws {
        for migration in migrations {
            try await migration.execute()
        }
    }
}
