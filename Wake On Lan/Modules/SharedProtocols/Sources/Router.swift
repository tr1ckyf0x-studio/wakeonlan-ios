//
//  Router.swift
//  Wake on LAN
//
//  Created by Владислав Лисянский on 23.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit

public protocol Router {
    associatedtype ViewControllerType: UIViewController

    var viewController: ViewControllerType? { get }

    func popCurrentController(animated: Bool)
}

public extension Router {
    func popCurrentController(animated: Bool) {
        guard let navigationController = viewController?.navigationController else { return }
        navigationController.popViewController(animated: animated)
    }
}
