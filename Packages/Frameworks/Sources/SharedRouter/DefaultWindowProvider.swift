//
//  DefaultWindowProvider.swift
//  
//
//  Created by Dmitry Stavitsky on 17.09.2022.
//

import RouteComposer
import UIKit

/// Default implementation of the `WindowProvider` protocol
public final class DefaultWindowProvider: WindowProvider {

    // MARK: - Properties

    public var window: UIWindow? {
        guard
            let window = UIApplication.shared.delegate?.window
        else {
            assertionFailure("Application doesn't have default window.")
            return nil
        }
        return window
    }

    // MARK: - Init

    public init() { }
}
