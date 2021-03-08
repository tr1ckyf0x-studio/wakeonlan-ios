//
//  WOLNavigationController.swift
//  WOLUIComponents
//
//  Created by Dmitry on 08.03.2021.
//  Copyright © 2021 Владислав Лисянский. All rights reserved.
//

import UIKit
import WOLResources

public class WOLNavigationController: UINavigationController {

    override public init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Private

private extension WOLNavigationController {

    private func configure() {
        // Change background color
        navigationBar.barTintColor = R.color.soft()

        // Remove bottom line
        navigationBar.shadowImage = UIImage()
        navigationBar.setBackgroundImage(UIImage(), for: .default)

        // Change color of tappable items
        navigationBar.tintColor = R.color.soft()
        navigationBar.isTranslucent = false
    }

}
