//
//  FormValidable.swift
//  Wake on LAN
//
//  Created by Владислав Лисянский on 17.11.2022.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import Foundation

public protocol FileManagerProtocol {
    func urls(for directory: FileManager.SearchPathDirectory, in domainMask: FileManager.SearchPathDomainMask) -> [URL]
    func contentsOfDirectory(atPath path: String) throws -> [String]
    func containerURL(forSecurityApplicationGroupIdentifier groupIdentifier: String) -> URL?
    func removeItem(at: URL) throws
}

extension FileManager: FileManagerProtocol { }
