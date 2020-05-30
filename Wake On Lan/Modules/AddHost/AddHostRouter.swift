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

    private enum Constants {
        // NOTE: 57 - Cancel height
        static let topAnchor = 45
        static let bottomAnchor = 57 + 16
        static let baseViewHeight = 300
    }

    convenience init(with chooseIconView: UIView) {
        // TODO: R.swift
        self.init(title: "Choose Icon", message: nil, preferredStyle: .actionSheet)
        chooseIconView.backgroundColor = .clear
        view.snp.makeConstraints {
            $0.height.equalTo(Constants.baseViewHeight) // Ugly solution
        }
        view.addSubview(chooseIconView)
        chooseIconView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.topAnchor)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-Constants.bottomAnchor)
        }
        // TODO: R.swift
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        addAction(cancelAction)
    }

}
