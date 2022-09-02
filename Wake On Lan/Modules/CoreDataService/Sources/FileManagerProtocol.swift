import Foundation

// sourcery: AutoMockable
protocol FileManagerProtocol {
    func urls(for directory: FileManager.SearchPathDirectory, in domainMask: FileManager.SearchPathDomainMask) -> [URL]
    func contentsOfDirectory(atPath path: String) throws -> [String]
    func containerURL(forSecurityApplicationGroupIdentifier groupIdentifier: String) -> URL?
    func removeItem(at: URL) throws
}

extension FileManager: FileManagerProtocol { }
