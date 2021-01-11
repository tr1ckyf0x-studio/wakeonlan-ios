//
//  HostListRouter.swift
//  Wake On Lan
//
//  Created by Владислав Лисянский on 27.04.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit
import CoreDataService
import AddHost

final class HostListRouter: HostListRouterProtocol {

    weak var viewController: UIViewController?

    func routeToAddHost(with host: Host? = nil) {
        let addHostViewController = AddHostViewController()
        let addHostConfigurator = AddHostConfigurator()
        addHostConfigurator.configure(viewController: addHostViewController, with: host)
        viewController?.navigationController?.pushViewController(
            addHostViewController,
            animated: true
        )
    }

}
