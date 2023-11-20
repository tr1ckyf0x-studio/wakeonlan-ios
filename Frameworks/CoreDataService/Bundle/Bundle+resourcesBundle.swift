//
//  Bundle+CoreDataServiceResources.swift
//  CoreDataService
//
//  Created by Vladislav Lisianskii on 31.08.2023.
//

import Foundation

extension Bundle {
    static var resourcesBundle: Bundle {
        guard let bundle = BundleToken
            .bundle
            .url(
                forResource: "CoreDataServiceResources",
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
