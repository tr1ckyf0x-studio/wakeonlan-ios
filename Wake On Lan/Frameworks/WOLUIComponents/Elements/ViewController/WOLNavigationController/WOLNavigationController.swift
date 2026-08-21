//
//  WOLNavigationController.swift
//  WOLUIComponents
//
//  Created by Dmitry on 08.03.2021.
//  Copyright © 2021 Vladislav Lisianskii. All rights reserved.
//

import UIKit

public class WOLNavigationController: UINavigationController {
    override public init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        configure()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private

private extension WOLNavigationController {
    private func configure() {
        // Change background color
        navigationBar.barTintColor = UIColor(resource: .primary)

        // Remove bottom line
        navigationBar.shadowImage = UIImage()
        navigationBar.setBackgroundImage(UIImage(), for: .default)

        // Change color of tappable items
        navigationBar.tintColor = UIColor(resource: .primary)
        navigationBar.isTranslucent = false

        let largeTitleTextAttributes = [
            NSAttributedString.Key.font:
                UIFont.boldSystemFont(ofSize: 36),
            NSAttributedString.Key.foregroundColor:
                UIColor(resource: .secondaryVariant)
        ]
        navigationBar.largeTitleTextAttributes = largeTitleTextAttributes

        let titleTextAttributes = [
            NSAttributedString.Key.foregroundColor:
                UIColor(resource: .secondaryVariant)
        ]
        navigationBar.titleTextAttributes = titleTextAttributes
    }
}
