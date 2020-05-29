//
//  AddHostRouter.swift
//  Wake on LAN
//
//  Created by Владислав Лисянский on 23.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit

class AddHostRouter: AddHostRouterProtocol {
    var viewController: UIViewController?

    func routeToChooseIcon() {
        let chooseViewController = ChooseIconViewController()
        guard let viewController = self.viewController else { return }
//        viewController.presentAsSheet(chooseViewController, height: 500)
//        viewController.navigationController?.pushViewController(chooseViewController, animated: true)
        showPickerController()
    }

    func showPickerController() {
        let alertController = UIAlertController(title: "Choose Icon", message: nil, preferredStyle: .actionSheet)
        let chooseViewController = ChooseIconViewController()
        let customView = chooseViewController.view
        customView?.backgroundColor = .clear
        chooseViewController.loadViewIfNeeded()

        alertController.view.addSubview(customView!)
        customView!.translatesAutoresizingMaskIntoConstraints = false
        customView!.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 45).isActive = true
        customView!.rightAnchor.constraint(equalTo: alertController.view.rightAnchor, constant: -10).isActive = true
        customView!.leftAnchor.constraint(equalTo: alertController.view.leftAnchor, constant: 10).isActive = true

        customView!.bottomAnchor.constraint(equalTo: alertController.view.bottomAnchor, constant: 0).isActive = true

//        customView!.heightAnchor.constraint(equalToConstant: 250).isActive = true

        alertController.view.translatesAutoresizingMaskIntoConstraints = false
        alertController.view.heightAnchor.constraint(equalToConstant: 300).isActive = true

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        alertController.addAction(selectAction)
        alertController.addAction(cancelAction)
//        self.present(alertController, animated: true, completion: nil)
        viewController!.present(alertController, animated: true)
    }

}


