import CoreData

public final class CoreDataAppToSharedGroupMigration: CoreDataMigration, CoreDataMigrationInternal {

    var coreDataService: (CoreDataServiceProtocol & CoreDataServiceInternalProtocol)?

    private let fileManager: FileManagerProtocol

    init(
        fileManagerProtocol: FileManagerProtocol
    ) {
        self.fileManager = fileManagerProtocol
    }

    public convenience init(
        fileManager: FileManager = .default
    ) {
        self.init(
            fileManagerProtocol: fileManager
        )
    }

    public func execute() async throws {
        guard let coreDataService = coreDataService else {
            fatalError("coreDataService is null")
        }

        guard let oldDatabaseURL = try oldDatabaseURL() else {
            // Migration not required
            return
        }

        guard let targetDatabaseURL = CoreDataConstants.persistentContainerURL else {
            throw Error.sharedGroupDirectoryIsUnavailable
        }

        let persistentStoreCoordinator = NSPersistentStoreCoordinator(
            managedObjectModel: coreDataService.managedObjectModel
        )

        try persistentStoreCoordinator.replacePersistentStore(
            at: targetDatabaseURL,
            withPersistentStoreFrom: oldDatabaseURL,
            ofType: NSSQLiteStoreType
        )

        try removeOldDatabaseFiles()
    }
}

// MARK: - Private methods
extension CoreDataAppToSharedGroupMigration {
    private var applicationSupportDirectoryURL: URL? {
        fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).last
    }

    private func files(containing substring: String, at directoryURL: URL) throws -> [URL] {
        let path = directoryURL.path
        let filesList = try fileManager.contentsOfDirectory(atPath: path).filter { filename in
            filename.contains(substring)
        }
        let urls = filesList.map { filename in
            directoryURL.appendingPathComponent(filename)
        }
        return urls
    }

    private func oldDatabaseFileURLs() throws-> [URL] {
        guard let applicationSupportDirectoryURL = applicationSupportDirectoryURL else {
            throw Error.applicationSupportDirectoryURLNotFound
        }
        return try files(
            containing: CoreDataConstants.persistentContainerName,
            at: applicationSupportDirectoryURL
        )
    }

    private func oldDatabaseURL() throws -> URL? {
        try oldDatabaseFileURLs().first(where: { (url: URL) -> Bool in
            url.pathComponents.contains(CoreDataConstants.persistentContainerFilename)
        })
    }

    private func removeOldDatabaseFiles() throws {
        let oldDatabaseFiles = try oldDatabaseFileURLs()
        for oldDatabaseFile in oldDatabaseFiles {
            let fileCoordinator = NSFileCoordinator(filePresenter: nil)
            var deletionError: Swift.Error?
            fileCoordinator.coordinate(
                writingItemAt: oldDatabaseFile,
                options: .forDeleting,
                error: nil,
                byAccessor: { (url: URL) in
                    do {
                        try fileManager.removeItem(at: url)
                    } catch {
                        deletionError = error
                    }
                }
            )
            if let deletionError = deletionError {
                throw deletionError
            }
        }
    }
}

// MARK: - Error
extension CoreDataAppToSharedGroupMigration {
    private enum Error: LocalizedError {
        case applicationSupportDirectoryURLNotFound
        case sharedGroupDirectoryIsUnavailable
    }
}
