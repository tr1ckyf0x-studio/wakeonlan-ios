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

    /// Default router object that must be responsibe for navigation
    public let defaultRouter: Router
    /// Default stack iterator object that must be responsibe for navigation
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
