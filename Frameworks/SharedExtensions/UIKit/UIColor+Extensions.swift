//
//  UIColor+Extensions.swift
//  SharedExtensions
//
//  Created by Dmitry on 08.02.2021.
//  Copyright © 2021 Vladislav Lisianskii. All rights reserved.
//

import UIKit

public extension UIColor {
    var resolved: CGColor {
        self.resolvedColor(with: .current).cgColor
    }
}
