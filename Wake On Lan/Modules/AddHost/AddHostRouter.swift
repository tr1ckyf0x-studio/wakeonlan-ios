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
        let chooseIconViewController = ChooseIconViewController()
        guard let chooseIconView = chooseIconViewController.view as? ChooseIconView,
            let presentingViewController = viewController else { return }
        let alertController = UIAlertController(with: chooseIconView,
                                                presentingViewController: presentingViewController)
        viewController?.present(alertController, animated: true)
    }

}


// NOTE: We should not subclass UIAlertController
private extension UIAlertController {

    private enum Constants {
        // NOTE: 57 - Cancel button height
        static let topAnchor: CGFloat = 45
        static let bottomAnchor: CGFloat = 57 + 16
    }

    convenience init(with chooseIconView: ChooseIconView,
                     presentingViewController: UIViewController) {
        self.init(title: R.string.addHost.chooseIcon(), message: nil, preferredStyle: .actionSheet)
        chooseIconView.backgroundColor = .clear
        guard let layout =
            chooseIconView.collectionView.collectionViewLayout as? ChooseIconCollectionLayout else {
                return
        }
        layout.containerWidth = presentingViewController.view.bounds.width
        let viewHeight = layout.containerHeight + Constants.bottomAnchor + Constants.topAnchor
        view.snp.makeConstraints {
            $0.height.equalTo(viewHeight)
        }
        view.addSubview(chooseIconView)
        chooseIconView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.topAnchor)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-Constants.bottomAnchor)
        }
        let cancelAction = UIAlertAction(title: R.string.addHost.cancel(), style: .cancel)
        addAction(cancelAction)
    }

}
