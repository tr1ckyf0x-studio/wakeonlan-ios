//
//  CGSize + Extensions.swift
//  SharedExtensions
//
//  Created by Dmitry on 08.02.2021.
//  Copyright © 2021 Владислав Лисянский. All rights reserved.
//

import CoreGraphics

public extension CGSize {
    var inverse: CGSize { .init(width: -1 * width, height: -1 * height) }
}
