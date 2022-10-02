import Foundation
@testable import WOLResources

extension BundleInfo {
    public static let testData =
    BundleInfo(
        displayName: UUID().uuidString,
        identifier: UUID().uuidString,
        name: UUID().uuidString,
        version: UUID().uuidString,
        build: UUID().uuidString,
        appFonts: nil)
}
