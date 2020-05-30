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

    func reloadCollectionViewLayout()
}

protocol ChooseIconViewOutput {
    var tableManager: ChooseIconTableManager { get }

    func viewDidLoad(_ view: ChooseIconViewInput)

    func viewWillLayoutSubviews(_ view: ChooseIconViewInput)
}

extension ChooseIconViewOutput {
    func viewDidLoad(_ view: ChooseIconViewInput) { }

    func viewWillLayoutSubviews(_ view: ChooseIconViewInput) { }
}

protocol ChooseIconRouterProtocol: class {
    var viewController: ChooseIconViewInput? { get }

}
