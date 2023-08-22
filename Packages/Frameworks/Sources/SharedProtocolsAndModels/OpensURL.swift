//
//  URLOpener.swift
//  AboutScreen
//
//  Created by Dmitry on 05.08.2021.
//  Copyright © 2021 Владислав Лисянский. All rights reserved.
//

import UIKit

public protocol OpensURL {
    /// Opens provided URL
    func open(url: URL)
}

extension UIApplication: OpensURL {
    public func open(url: URL) {
        open(url)
    }
}
