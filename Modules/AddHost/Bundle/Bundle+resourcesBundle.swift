//  Created by Vladislav Lisianskii on 05.11.2023.

import Foundation

extension Bundle {
    static var resourcesBundle: Bundle {
        guard let bundle = BundleToken
            .bundle
            .url(forResource: "AddHostResources", withExtension: "bundle")
            .flatMap(Bundle.init(url:))
        else { fatalError("Bundle not found.") }
        return bundle
    }
}

// swiftlint:disable:next convenience_type
private final class BundleToken {

    @available(*, unavailable)
    init() { }

    static var bundle: Bundle {
        Bundle(for: BundleToken.self)
    }
}
