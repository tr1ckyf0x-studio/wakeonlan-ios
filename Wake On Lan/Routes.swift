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
import SharedProtocolsAndModels
import SharedRouter
import UIKit
import WOLUIComponents

/// General registry of the routes
///
/// - NOTE: New routes should be added in alphabetical order

// MARK: - PostLaunchRoutes

extension WOLRouter: PostLaunchRoutes { }

extension WOLRouter {
    /// Navigates to `HostList` screen.
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
    /// Navigates to `AddHost` screen.
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

    /// Navigates to `About` screen.
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

// MARK: - ChooseIconRoutes

extension WOLRouter: ChooseIconRoutes { }

// MARK: - AddHostRoutes

extension WOLRouter: AddHostRoutes {
    typealias ChooseIconFinder = ClassFinder<ChooseIconFactory.ViewController, ChooseIconFactory.Context>

    /// Navigates to `ChooseIcon` screen.
    public func openChooseIcon(with context: ChooseIconFactory.Context) -> SharedRouter.Route {
        Route {
            let delegate = SelfSizingBottomSheetModalTransitionDelegate()
            let step = StepAssembly(finder: ChooseIconFinder(), factory: ChooseIconFactory(router: self))
                .using(GeneralAction.presentModally(presentationStyle: .custom, transitioningDelegate: delegate))
                .from(GeneralStep.current())
                .assemble()
            try? defaultRouter.navigate(to: step, with: context, animated: true, completion: $0)
        }
    }
}
