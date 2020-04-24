//
//  HostListContract.swift
//  Wake On Lan
//
//  Created by Владислав Лисянский on 27.04.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import Foundation

protocol HostListViewOutput: class {
    func viewDidPressAddButton(_ view: HostListViewInput)
}

protocol HostListViewInput: class {
    
}

protocol HostListInteractorInput: class {
    
}

protocol HostListInteractorOutput: class {
    
}

protocol HostListRouterProtocol: class {
    func routeToAddHost()
}


