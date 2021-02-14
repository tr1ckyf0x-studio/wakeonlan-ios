//
//  Form.swift
//  Wake on LAN
//
//  Created by Владислав Лисянский on 17.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import SharedModels

public protocol AddHostFormRepresentable: Validable {
    associatedtype SectionType: AddHostFormSectionRepresentable = Void

    var sections: [SectionType] { get }
    var iconModel: IconModel? { get set }
    var title: String? { get }
    var macAddress: String? { get }
    var ipAddress: String? { get }
    var port: String? { get }
}
