import Foundation
import WOLSharedProtocolsAndModels

enum CoreDataConstants {
    static let persistentContainerName = "HostsDataModel"
    static let persistentContainerFilename: String = "\(persistentContainerName).sqlite"

    static var persistentContainerURL: URL? {
        appGroupDirectoryURL?.appendingPathComponent(CoreDataConstants.persistentContainerFilename)
    }

    static var managedModelURL: URL? {
        Bundle.resourcesBundle.url(forResource: persistentContainerName, withExtension: "momd")
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
