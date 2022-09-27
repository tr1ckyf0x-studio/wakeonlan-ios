import Foundation
@testable import WOLResources

extension BundleInfo {
    public static let shared = BundleInfo(
        displayName: testData.displayName,
        identifier: testData.identifier,
        name: testData.name,
        version: testData.version,
        build: testData.build,
        appFonts: nil
    )
   private static let testData =
        BundleInfo(
        displayName: String.randomString(length: 10),
        identifier: String.randomString(length: 10),
        name: String.randomString(length: 10),
        version: String.randomString(length: 10),
        build: String.randomString(length: 10),
        appFonts: nil)
}
