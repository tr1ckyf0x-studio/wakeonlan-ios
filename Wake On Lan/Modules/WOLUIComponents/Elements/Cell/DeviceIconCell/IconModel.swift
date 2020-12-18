//
//  IconModel.swift
//  WOLUIComponents
//
//  Created by Dmitry on 13.12.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import Foundation
import WOLResources

public struct IconModel {
    public let pictureName: String

    public init(pictureName: String = R.image.other.name) {
        self.pictureName = pictureName
    }
}

extension IconModel: Equatable {
    public static func == (lhs: IconModel, rhs: IconModel) -> Bool {
        lhs.pictureName == rhs.pictureName
    }
}
