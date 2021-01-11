//
//  AddHostFormSectionRepresentable.swift
//  Wake on LAN
//
//  Created by Dmitry on 24.12.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

public protocol AddHostFormSectionRepresentable {
    associatedtype Item
    associatedtype Header: Mandatoryable
    associatedtype Footer: Mandatoryable
    associatedtype KindType

    var items: [Item] { get }
    var header: Header? { get }
    var footer: Footer? { get }
    var kind: KindType { get }
}
