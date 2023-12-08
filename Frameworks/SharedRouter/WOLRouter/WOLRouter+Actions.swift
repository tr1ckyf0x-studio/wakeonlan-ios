//
//  WOLRouter+Actions.swift
//  
//
//  Created by Dmitry Stavitsky on 16.10.2022.
//

import RouteComposer
import UIKit

public extension WOLRouter {
    func defaultStepRoutePushAction<F: Factory>(
        factory: F,
        options: SearchOptions = .allVisible
    ) -> DestinationStep<F.ViewController, F.Context> {
        defaultStepRoute(action: UINavigationController.push(), factory: factory)
    }

    func defaultStepRoutePushAsRootAction<F: Factory>(
        factory: F,
        options: SearchOptions = .allVisible
    ) -> DestinationStep<F.ViewController, F.Context> {
        defaultStepRoute(action: UINavigationController.pushAsRoot(), factory: factory)
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

    private let _perform: (UIViewController, ViewController, Bool, @escaping (RoutingResult) -> Void) -> Void

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

/// Wrapper for any object that implements protocol `Action`.
public struct AnyAction<ViewController: UIViewController>: Action {

    // MARK: - Properties

    private let _perform: (UIViewController, ViewController, Bool, @escaping (RoutingResult) -> Void) -> Void

    // MARK: - Init

    public init<T: Action>(_ other: T) where T.ViewController == ViewController {
        _perform = other.perform(with:on:animated:completion:)
    }

    // MARK: - Action

    public func perform(
        with viewController: UIViewController,
        on existingController: ViewController,
        animated: Bool,
        completion: @escaping (RouteComposer.RoutingResult
        ) -> Void) {
        _perform(viewController, existingController, animated, completion)
    }
}
