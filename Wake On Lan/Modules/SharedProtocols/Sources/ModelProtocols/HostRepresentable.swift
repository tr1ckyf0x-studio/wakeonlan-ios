//
//  HostRepresentable.swift
//  
//
//  Created by Vladislav Lisianskii on 03.08.2021.
//

import Foundation

public protocol HostRepresentable {
    var macAddress: String? { get }
    var ipAddress: String? { get }
    var port: String? { get }
}
