//
//  HostListPresenter.swift
//  Wake On Lan
//
//  Created by Владислав Лисянский on 27.04.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import Foundation

class HostListPresenter {
    weak var view: HostListViewInput?
    var router: HostListRouterProtocol?
}

extension HostListPresenter: HostListViewOutput {
    func viewDidPressAddButton(_ view: HostListViewInput) {
        router?.routeToAddHost()
    }
}
