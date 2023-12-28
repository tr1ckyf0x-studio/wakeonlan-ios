//
//  AddHostFormRepresentable.swift
//  Wake on LAN
//
//  Created by Vladislav Lisianskii on 17.05.2020.
//  Copyright © 2020 Vladislav Lisianskii. All rights reserved.
//

public protocol AddHostFormRepresentable: Validable {
    associatedtype SectionType: AddHostFormSectionRepresentable

    /// Represents sections
    var sections: [SectionType] { get }

    /// Represents main icon header
    var iconModel: IconModel { get set }

    /// Represents host's title
    var title: String { get }

    /// Represents host's mac address
    var macAddress: String { get }

    /// Represents host's destination
    var destination: String? { get }

    /// Represents host's ip port
    var port: String? { get }
}
