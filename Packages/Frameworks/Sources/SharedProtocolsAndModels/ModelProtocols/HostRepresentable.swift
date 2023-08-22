//
//  HostRepresentable.swift
//  
//
//  Created by Vladislav Lisianskii on 03.08.2021.
//

public protocol HostRepresentable {
    /// Host's mac address
    var macAddress: String? { get }
    /// Host's ip address
    var ipAddress: String? { get }
    /// Host's port
    var port: String? { get }
}
