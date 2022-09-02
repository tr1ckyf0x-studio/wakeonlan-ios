import Foundation

enum CoreDataConstants {
    static let persistentContainerName = "HostsDataModel"
    static let persistentContainerExtension = "momd"
    static let sharedAppGroupIdentifier = "group.com.tr1ckyf0x.wake-on-lan.shared"
    static let persistentContainerFilename: String = "\(persistentContainerName).sqlite"
    static let iCloudContainerIdentifier = "iCloud.com.tr1ckyf0x.wake-on-lan"

    static var persistentContainerURL: URL? {
        appGroupDirectoryURL?.appendingPathComponent(CoreDataConstants.persistentContainerFilename)
    }
}

// MARK: - Private methods
extension CoreDataConstants {
    private static var appGroupDirectoryURL: URL? {
        FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: CoreDataConstants.sharedAppGroupIdentifier
        )
    }
}
