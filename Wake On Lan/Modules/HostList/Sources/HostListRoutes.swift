//
//  HostListRoutes.swift
//  Wake On Lan
//
//  Created by Владислав Лисянский on 27.04.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import AddHost
import AboutScreen
import CoreDataService
import SharedRouter
import UIKit

public protocol HostListRoutes {
    /// Navigates to `AddHost` screen
    func openAddHost(with host: Host?) -> Route
    /// Navigates to `About` screen
    func openAbout() -> Route
}

//final class HostListRoutes: HostListRouterProtocol {
//
////    func openAddHost
//
////    weak var viewController: UIViewController?
//
//
////    func routeToAddHost(with host: Host? = nil) {
////        let addHostViewController = AddHostViewController()
////        let addHostConfigurator = AddHostFactory()
////        addHostConfigurator.configure(viewController: addHostViewController, with: host)
////        viewController?.navigationController?.pushViewController(
////            addHostViewController,
////            animated: true
////        )
////    }
////
////    func routeToAbout() {
////        let aboutScreenViewController = AboutScreenViewController()
////        let aboutScreenConfigurator = AboutScreenConfigurator(router: nil)
////        aboutScreenConfigurator.configure(viewController: aboutScreenViewController)
////        viewController?.navigationController?.pushViewController(
////            aboutScreenViewController,
////            animated: true
////        )
////    }
//}
