//
//  IconModel.swift
//  WOLUIComponents
//
//  Created by Dmitry on 13.12.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import WOLResources

public protocol IconModelRepresentable {
    var pictureName: String { get }
}

public struct IconModel: IconModelRepresentable {
    public let pictureName: String

    public init(pictureName: String = WOLResources.Asset.Assets.other.name) {
        self.pictureName = pictureName
    }
}

// MARK: - Equatable

extension IconModel: Equatable {
    public static func == (lhs: IconModel, rhs: IconModel) -> Bool {
        lhs.pictureName == rhs.pictureName
    }
}
