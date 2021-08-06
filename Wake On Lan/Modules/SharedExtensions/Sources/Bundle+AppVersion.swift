//
//  Bundle+AppVersion.swift
//  SharedExtensions
//
//  Created by Vladislav Lisianskii on 23.05.2021.
//  Copyright © 2021 Владислав Лисянский. All rights reserved.
//

import Foundation

public extension Bundle {
    var appVersion: String? {
        infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersion: String? {
        infoDictionary?["CFBundleVersion"] as? String
    }
}
