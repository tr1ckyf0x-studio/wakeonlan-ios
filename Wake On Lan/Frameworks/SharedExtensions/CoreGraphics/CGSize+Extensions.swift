//
//  CGSize + Extensions.swift
//  SharedExtensions
//
//  Created by Dmitry on 08.02.2021.
//  Copyright © 2021 Vladislav Lisianskii. All rights reserved.
//

import CoreGraphics

public extension CGSize {
    var inversed: CGSize { .init(width: -1 * width, height: -1 * height) }
}
