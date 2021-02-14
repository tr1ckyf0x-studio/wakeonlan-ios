//
//  UIColor+Extensions.swift
//  SharedExtensions
//
//  Created by Dmitry on 08.02.2021.
//  Copyright © 2021 Владислав Лисянский. All rights reserved.
//

import UIKit

public extension UIColor {
    var resolved: CGColor {
        if #available(iOS 13.0, *) {
            return self.resolvedColor(with: .current).cgColor
        } else {
            return self.cgColor
        }
    }
}
