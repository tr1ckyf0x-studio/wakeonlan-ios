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
        let chooseIconView = ChooseIconViewController()
        let alertController = UIAlertController(with: chooseIconView.view)
        viewController?.present(alertController, animated: true)
    }

}


// NOTE: We should not subclass UIAlertController
private extension UIAlertController {

    convenience init(with chooseIconView: UIView) {
        // TODO: R.swift
        self.init(title: "Choose Icon", message: nil, preferredStyle: .actionSheet)
        chooseIconView.backgroundColor = .clear
        view.snp.makeConstraints {
            $0.height.equalTo(300) // Ugly solution
        }
        view.addSubview(chooseIconView)
        chooseIconView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(45)
            $0.leading.trailing.equalToSuperview()
            let bottomAnchor = (57 + 16) // 57 - Cancel height
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-bottomAnchor)
        }
        // TODO: R.swift
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        addAction(cancelAction)
    }

}
