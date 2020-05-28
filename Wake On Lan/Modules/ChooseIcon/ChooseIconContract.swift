//
//  ChooseIconContract.swift
//  Wake on LAN
//
//  Created by Dmitry Stavitsky on 28.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit

protocol ChooseIconViewInput: UIViewController {
    var presenter: ChooseIconViewOutput! { get set }
}

protocol ChooseIconViewOutput {
    var tableManager: ChooseIconTableManager { get }

    func viewDidLoad(_ view: ChooseIconViewInput)
}

protocol ChooseIconRouterProtocol: class {
    var viewController: ChooseIconViewInput? { get }

}
