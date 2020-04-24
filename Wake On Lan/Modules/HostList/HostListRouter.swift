//
//  HostListRouter.swift
//  Wake On Lan
//
//  Created by Владислав Лисянский on 27.04.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit

class HostListRouter: HostListRouterProtocol {
    weak var viewController: UIViewController?
    
    func routeToAddHost() {
        let addHostViewController = AddHostViewController()
        viewController?.navigationController?.pushViewController(addHostViewController, animated: true)
    }
}
