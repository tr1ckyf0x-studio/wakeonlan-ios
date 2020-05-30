//
//  ChooseIconViewController.swift
//  Wake on LAN
//
//  Created by Dmitry Stavitsky on 28.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit

class ChooseIconViewController: UIViewController {

    // MARK: - Properties
    var presenter: ChooseIconViewOutput!
    private lazy var chooseIconView = ChooseIconView(frame: .zero)

    // MARK: - Lifecycle
    override func loadView() {
        self.view = chooseIconView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let configurator = ChooseIconConfigurator()
        configurator.configure(viewController: self)
        chooseIconView.collectionView.delegate = presenter.tableManager
        chooseIconView.collectionView.dataSource = presenter.tableManager
        presenter.viewDidLoad(self)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        presenter.viewWillLayoutSubviews(self)
    }

}

// MARK: - ChooseIconViewInput
extension ChooseIconViewController: ChooseIconViewInput {

    func reloadCollectionViewLayout() {
        guard let layout =
            chooseIconView.collectionView.collectionViewLayout as? ChooseIconCollectionLayout else {
                return
        }
        layout.containerWidth = view.bounds.size.width
    }

}
