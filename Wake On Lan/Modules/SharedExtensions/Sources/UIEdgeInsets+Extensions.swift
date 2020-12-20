//
//  UIEdgeInsets+Extensions.swift
//  SharedExtensions
//
//  Created by Dmitry on 19.12.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit

public extension UIEdgeInsets {

    init(offset: CGFloat) {
        self.init(top: offset, left: offset, bottom: offset, right: offset)
    }

}
