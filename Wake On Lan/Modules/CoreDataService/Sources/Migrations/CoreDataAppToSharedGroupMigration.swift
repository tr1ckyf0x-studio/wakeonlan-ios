import CoreData
import SharedProtocolsAndModels

public final class CoreDataAppToSharedGroupMigration: CoreDataMigration {

    private let coreDataService: CoreDataServiceProtocol
    private let fileManager: FileManagerProtocol

    public init(
        coreDataService: CoreDataServiceProtocol,
        fileManager: FileManagerProtocol
    ) {
        self.coreDataService = coreDataService
        self.fileManager = fileManager
    }

    public func execute() async throws {
        guard let oldDatabaseURL = try fetchOldDatabaseURL() else {
            // Migration not required
            // TODO: Add log
            return
        }

        guard let targetDatabaseURL = CoreDataConstants.persistentContainerURL else {
            throw Error.sharedGroupDirectoryIsUnavailable
        }

        try coreDataService.persistentStoreCoordinator.replacePersistentStore(
            at: targetDatabaseURL,
            withPersistentStoreFrom: oldDatabaseURL,
            ofType: NSSQLiteStoreType
        )

        try await removeOldDatabaseFiles()
    }
}

// MARK: - Private methods
extension CoreDataAppToSharedGroupMigration {
    private var applicationSupportDirectoryURL: URL? {
        fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).last
    }

    private func fetchFiles(containing substring: String, at directoryURL: URL) throws -> [URL] {
        let path = directoryURL.path
        let filesList = try fileManager.contentsOfDirectory(atPath: path).filter { (filename: String) -> Bool in
            filename.contains(substring)
        }
        let urls = filesList.map { (filename: String) -> URL in
            directoryURL.appendingPathComponent(filename)
        }
        return urls
    }

    private func fetchOldDatabaseFileURLs() throws -> [URL] {
        guard let applicationSupportDirectoryURL = applicationSupportDirectoryURL else {
            throw Error.applicationSupportDirectoryURLNotFound
        }
        return try fetchFiles(
            containing: CoreDataConstants.persistentContainerName,
            at: applicationSupportDirectoryURL
        )
    }

    private func fetchOldDatabaseURL() throws -> URL? {
        try fetchOldDatabaseFileURLs().first(where: { (url: URL) -> Bool in
            url.pathComponents.contains(CoreDataConstants.persistentContainerFilename)
        })
    }

    private func removeOldDatabaseFiles() async throws {
        let oldDatabaseFiles = try fetchOldDatabaseFileURLs()
        await withThrowingTaskGroup(of: Void.self) { group in
            oldDatabaseFiles.forEach { (oldDatabaseFile: URL) in
                group.addTask(priority: .utility) { [self] in
                    try removeFile(at: oldDatabaseFile)
                }
            }
        }
    }

    private func removeFile(at url: URL) throws {
        let fileCoordinator = NSFileCoordinator(filePresenter: nil)
        var error: NSError?
        fileCoordinator.coordinate(
            writingItemAt: url,
            options: .forDeleting,
            error: &error,
            byAccessor: { (url: URL) in
                // If the item is unavailable for removal,
                // then it must not to be available for locking by fileCoordinator
                // Error is expected to be handled by fileCoordinator
                try? fileManager.removeItem(at: url)
            }
        )
        if let error {
            throw error
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
