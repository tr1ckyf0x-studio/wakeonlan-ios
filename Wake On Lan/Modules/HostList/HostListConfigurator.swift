//
//  HostListConfigurator.swift
//  Wake On Lan
//
//  Created by Владислав Лисянский on 27.04.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import Foundation

class HostListConfigurator {
    func configure(viewController: HostListViewController) {
        let presenter = HostListPresenter()
        let router = HostListRouter()
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        presenter.router = router
        router.viewController = viewController
    }
}
