//
//  Bundle+resourcesBundle.swift
//  DonateScreen
//
//  Created by Vladislav Lisianskii on 01.09.2023.
//

import Foundation

extension Bundle {
    static var resourcesBundle: Bundle {
        guard let bundle = BundleToken
            .bundle
            .url(
                forResource: "DonateScreenResources",
                withExtension: "bundle"
            )
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
