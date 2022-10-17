//
//  WOLRouter+Actions.swift
//  
//
//  Created by Dmitry Stavitsky on 16.10.2022.
//

import Foundation
import RouteComposer
import UIKit

//Route {
//    try? defaultRouter.navigate(to: defaultStepRoutePushAsRootAction(factory: HostListFactory()), with: nil, animated: false, completion: $0)
//}

public extension WOLRouter {
    func defaultStepRoutePushAsRootAction<F: Factory>(
        factory: F,
        options: SearchOptions = .allVisible
    ) -> DestinationStep<F.ViewController, F.Context> {
        defaultStepRoute(action: UINavigationController.pushAsRoot(), factory: factory)
    }

    func defaultStepRoutePushAction<F: Factory>(
        factory: F,
        options: SearchOptions = .allVisible
    ) -> DestinationStep<F.ViewController, F.Context> {
        defaultStepRoute(action: UINavigationController.push(), factory: factory)
    }
}

extension WOLRouter {
    private func defaultStepRoute<F: Factory, Action: ContainerAction>(
        action: Action,
        factory: F,
        options: SearchOptions = .allVisible
    ) -> DestinationStep<F.ViewController, F.Context> where Action.ViewController == UINavigationController {
        StepAssembly(finder: ClassFinder<F.ViewController, F.Context>(), factory: factory)
        .using(AnyNavigationControllerAction<UINavigationController>(action))
        .from(
            SingleContainerStep(
                finder: ClassFinder<UINavigationController, F.Context>(options: options),
                factory: NavigationControllerFactory()
            )
        )
        .using(GeneralAction.nilAction())
        .from(GeneralStep.current())
        .assemble()
    }
}

/// Wrapper for any object that implements protocol `ContainerAction`.
public struct AnyNavigationControllerAction<ViewController: ContainerViewController>: ContainerAction {
    // MARK: - Properties

    private let _perform: (UIViewController, ViewController, Bool, @escaping (RoutingResult) -> Void) -> ()

    // MARK: - Init

    public init<T: ContainerAction>(_ other: T) where T.ViewController == ViewController {
        _perform = other.perform(with:on:animated:completion:)

    }

    // MARK: - ContainerAction

    public func perform(
        with viewController: UIViewController,
        on existingController: ViewController,
        animated: Bool,
        completion: @escaping (RoutingResult) -> Void
    ) {
        _perform(viewController, existingController, animated, completion)
    }
}
