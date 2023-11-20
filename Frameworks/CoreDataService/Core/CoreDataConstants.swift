import Foundation
import SharedProtocolsAndModels

enum CoreDataConstants {
    static let persistentContainerName = "HostsDataModel"
    static let persistentContainerExtension = "momd"
    static let persistentContainerFilename: String = "\(persistentContainerName).sqlite"

    static var persistentContainerURL: URL? {
        appGroupDirectoryURL?.appendingPathComponent(CoreDataConstants.persistentContainerFilename)
    }
}

// MARK: - Private methods
extension CoreDataConstants {
    private static var appGroupDirectoryURL: URL? {
        FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: BundleConstants.sharedAppGroupIdentifier
        )
    }
}
