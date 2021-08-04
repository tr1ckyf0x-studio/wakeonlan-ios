//
//  URLOpener.swift
//  AboutScreen
//
//  Created by Dmitry on 05.08.2021.
//  Copyright © 2021 Владислав Лисянский. All rights reserved.
//

import UIKit

// TODO: Move to common framework

protocol OpensURL {
    /// Opens provided URL
    func open(url: URL)
}

struct URLOpener: OpensURL {
    func open(url: URL) {
        UIApplication.shared.open(url)
    }
}
