//
//  BundleInfoProvider.swift
//  WOLResources
//
//  Created by Dmitry on 18.12.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import Foundation

public protocol ProvidesBundleInfo {
    func fetchBundleInfo() -> BundleInfo
}

public final class BundleInfoProvider {

    private typealias Resource = (name: String, type: String)

    private enum Configuration {
        static let resource = Resource(name: "Info", type: "plist")
    }

    // MARK: - Init

    public init() { }
}

// MARK: - ProvidesBundleInfo

extension BundleInfoProvider: ProvidesBundleInfo {
    public func fetchBundleInfo() -> BundleInfo {
        guard
            let path = Bundle.main.path(
                forResource: Configuration.resource.name,
                ofType: Configuration.resource.type
            ),
            let plist = FileManager.default.contents(atPath: path),
            let bundleInfo = try? PropertyListDecoder().decode(BundleInfo.self, from: plist) else {
            fatalError("\(self) : Can't get bundle info!")
        }
        return bundleInfo
    }
}
