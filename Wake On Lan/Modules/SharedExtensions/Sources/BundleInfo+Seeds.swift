import Foundation
@testable import WOLResources

extension BundleInfo {
    static let testData = BundleInfo(
        displayName: String().randomString(length: 10),
        identifier: String().randomString(length: 10),
        name: String().randomString(length: 10),
        version: String().randomString(length: 10),
        build: String().randomString(length: 10),
        appFonts: nil)
}
