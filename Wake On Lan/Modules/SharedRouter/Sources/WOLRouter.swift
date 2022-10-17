//
//  WOLRouter.swift
//  
//
//  Created by Dmitry Stavitsky on 16.10.2022.
//

import RouteComposer
import UIKit

public struct WOLRouter {

    // MARK: - Properties

    public let defaultRouter: Router
    public let defaultStackIterator: StackIterator

    // MARK: - Init

    public init(
        defaultRouter: Router = DefaultRouter(),
        defaultStackIterator: StackIterator = RouteComposerDefaults.shared.stackIterator
    ) {
        self.defaultRouter = defaultRouter
        self.defaultStackIterator = defaultStackIterator
    }
}
