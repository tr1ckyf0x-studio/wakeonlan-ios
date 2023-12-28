//
//  Routes+AddHost.swift
//  Wake on LAN
//
//  Created by Dmitry Stavitsky on 11.11.2022.
//  Copyright © 2022 Vladislav Lisianskii. All rights reserved.
//

import AddHost
import RouteComposer
import SharedRouter
import WOLUIComponents

extension WOLRouter: AddHostRoutes {
    typealias ChooseIconClassFinder = ClassFinder<ChooseIconFactory.ViewController, ChooseIconFactory.Context>

    /// Navigates to `ChooseIcon` screen.
    public func openChooseIcon(with context: ChooseIconFactory.Context) -> SharedRouter.Route {
        Route {
            let delegate = SelfSizingBottomSheetModalTransitionDelegate()
            let step = StepAssembly(finder: ChooseIconClassFinder(), factory: ChooseIconFactory(router: self))
                .using(GeneralAction.presentModally(presentationStyle: .custom, transitioningDelegate: delegate))
                .from(GeneralStep.current())
                .assemble()
            try? defaultRouter.navigate(to: step, with: context, animated: true, completion: $0)
        }
    }
}
