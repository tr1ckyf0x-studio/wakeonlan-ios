//
//  UIImage+Extension.swift
//  WOLResources
//
//  Created by Dmitry on 19.12.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit

public extension UIImage {

    convenience init?(named: String) {
        self.init(
            named: named,
            in: .init(for: type(of: Dummy().self)),
            compatibleWith: nil
        )
    }

    private class Dummy { }

}
