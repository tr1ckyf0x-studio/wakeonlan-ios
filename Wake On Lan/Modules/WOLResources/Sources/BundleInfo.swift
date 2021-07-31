//
//  BundleInfo.swift
//  WOLResources
//
//  Created by Dmitry on 18.12.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import Foundation

public struct BundleInfo {
    public let displayName: String
    public let identifier: String
    public let name: String
    public let version: String
    public let appFonts: [String]?
}

// MARK: - Codable

extension BundleInfo: Codable {
    private enum CodingKeys: String, CodingKey {
        case displayName = "CFBundleDisplayName"
        case identifier = "CFBundleIdentifier"
        case version = "CFBundleVersion"
        case name = "CFBundleName"
        case appFonts = "UIAppFonts"
    }
}
