//
//  AddHostFormSectionRepresentable.swift
//  Wake on LAN
//
//  Created by Dmitry on 24.12.2020.
//  Copyright © 2020 Vladislav Lisianskii. All rights reserved.
//

public protocol AddHostFormSectionRepresentable {
    associatedtype Item
    associatedtype Header: Mandatoryable
    associatedtype Footer: Mandatoryable
    associatedtype KindType

    /// Represents section's items
    var items: [Item] { get }

    /// Represents section's header
    var header: Header? { get }

    /// Represents section's footer
    var footer: Footer? { get }

    /// Kind of section (e.g title, mac address, ...)
    var kind: KindType { get }
}
