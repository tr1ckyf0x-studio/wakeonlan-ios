//
//  AddHostRouterMock.swift
//  WakeOnLanTests
//
//  Created by Владислав Лисянский on 01.11.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit
@testable import Wake_on_LAN

class AddHostRouterMock: AddHostRouterProtocol {

    weak var viewController: UIViewController?

    private(set) var didCallRouteToChooseIcon = false
    private(set) var didCallPopCurrentController = false

    func routeToChooseIcon() {
        didCallRouteToChooseIcon = true
    }

    func popCurrentController(animated: Bool) {
        didCallPopCurrentController = true
    }

}
