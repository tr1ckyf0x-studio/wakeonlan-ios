//
//  WOLRouter+CommonRoutes.swift
//  
//
//  Created by Dmitry Stavitsky on 16.10.2022.
//

import Foundation
import RouteComposer
import UIKit

public extension WOLRouter {
    func backOrDismiss(animated: Bool) -> SharedRouter.Route {
        let classFinder: ClassFinder<UIViewController, Any?> = makeClassFinder()
        if
            let topController = try? classFinder.findViewController(with: nil),
            let presentingVC = topController.presentingViewController {
            if
                let topNavigationController = topController as? UINavigationController,
                topNavigationController.viewControllers.count > 1 {
                return back(animated: animated)
            }
            return SharedRouter.Route { completion in
                presentingVC.dismiss(animated: animated) {
                    completion(.success)
                }
            }
        } else {
            return back(animated: animated)
        }
    }

    /// Default implementation of the `back` route
    ///
    /// - Note: Do not call directly. Use `backOrDismiss` instead.
    func back(animated: Bool) -> SharedRouter.Route {
        Route { completion in
            let classFinder: ClassFinder<UINavigationController, Any?> = makeClassFinder()
            guard
                let viewController = try? classFinder.findViewController(with: nil)
            else {
                return completion(.failure(RoutingError.generic(.init("Failed navigate to back"))))
            }
            let completionBlock: () -> Void = {
                completion(.success)
            }
            if
                let presentedViewController = viewController.presentedViewController {
                presentedViewController.dismiss(animated: animated, completion: completionBlock)
            } else {
                let action: () -> Void = {
                    viewController.popViewController(animated: animated)
                }
                guard animated else { action(); return completionBlock() }
                CATransaction.wrap(action: action, completion: completionBlock)
            }
        }
    }
}

extension WOLRouter {
    private func makeClassFinder<VC: UIViewController, C>() -> ClassFinder<VC, C> {
        ClassFinder<VC, C>(iterator: defaultStackIterator)
    }
}

private extension CATransaction {
    typealias Handler = () -> Void

    /// Wrap the action into transaction to track the end of the animation
    static func wrap(action: Handler, completion: @escaping Handler) {
        begin()
        setCompletionBlock(completion)
        action()
        commit()
    }
}
