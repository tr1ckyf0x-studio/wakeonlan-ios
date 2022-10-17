//
//  Routes.swift
//
//
//  Created by Dmitry Stavitsky on 17.09.2022.
//

import AboutScreen
import AddHost
import CoreDataService
import HostList
import PostLaunch
import RouteComposer
import SharedRouter
import SharedProtocolsAndModels
import UIKit

// MARK: - PostLaunchRoutes

extension WOLRouter: PostLaunchRoutes { }

extension WOLRouter {
    /// Navigates to `HostList` screen
    public func hostList() -> Route {
        Route {
            try? defaultRouter.navigate(
                to: defaultStepRoutePushAsRootAction(factory: HostListFactory(router: self)),
                with: nil,
                animated: false,
                completion: $0
            )
        }
    }
}

// MARK: - HostListRoutes

extension WOLRouter: HostListRoutes { }

extension WOLRouter {
    /// Navigates to `AddHost` screen
    public func openAddHost(with host: Host?) -> Route {
        Route {
            try? defaultRouter.navigate(
                to: defaultStepRoutePushAction(factory: AddHostFactory(router: self)),
                with: host,
                animated: true,
                completion: $0
            )
        }
    }

    /// Navigates to `About` screen
    public func openAbout() -> Route {
        Route {
            try? defaultRouter.navigate(
                to: defaultStepRoutePushAction(factory: AboutScreenFactory(router: self)),
                with: nil,
                animated: true,
                completion: $0
            )
        }
    }
}

// MARK: - AboutScreenRoutes

extension WOLRouter: AboutScreenRoutes { }

// MARK: - AddHostRoutes

extension WOLRouter: AddHostRoutes {
    public func openChooseIcon(moduleDelegate: ChooseIconModuleOutput?, transitioningDelegate: TransitioningDelegate?) -> Route {
        Route {
            try? defaultRouter.navigate(
                to: defaultStepRoutePushAction(factory: AddHostFactory(router: self)),
                with: nil,
                animated: true,
                completion: $0
            )
        }
    }
}
