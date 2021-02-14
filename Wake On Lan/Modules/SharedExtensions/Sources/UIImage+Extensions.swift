//
//  UIImage+Extensions.swift
//  SharedExtensions
//
//  Created by Dmitry on 14.02.2021.
//  Copyright © 2021 Владислав Лисянский. All rights reserved.
//

import UIKit

public extension UIImage {
    func with(tintColor: UIColor) -> UIImage {
        if #available(iOS 13.0, *) {
            return self.withTintColor(tintColor)
        } else {
            UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
            guard let context = UIGraphicsGetCurrentContext() else { return .init() }
            let rectangle = CGRect(origin: CGPoint.zero, size: size)

            tintColor.setFill()
            self.draw(in: rectangle)

            context.setBlendMode(.sourceIn)
            context.fill(rectangle)
            guard let tinted = UIGraphicsGetImageFromCurrentImageContext() else { return .init() }
            UIGraphicsEndImageContext()

            return tinted
        }
    }
}
