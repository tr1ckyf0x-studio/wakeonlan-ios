//
//  ChooseIconViewController.swift
//  Wake on LAN
//
//  Created by Dmitry Stavitsky on 28.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit

class ChooseIconViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let cornerRadius: CGFloat = 15.0
        static let animationDuration: TimeInterval = 0.5
    }

    // MARK: - Properties

    var presenter: ChooseIconViewOutput!

    private lazy var chooseIconView: ChooseIconView = {
        let view = ChooseIconView(frame: .zero)
        view.layer.cornerRadius = Constants.cornerRadius

        return view
    }()

    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(R.string.addHost.cancel(), for: .normal)
        button.backgroundColor = R.color.soft()
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20.0)
        button.layer.cornerRadius = Constants.cornerRadius
        button.addTarget(self, action: #selector(closeViewController), for: .touchUpInside)

        return button
    }()

    private var chooseIconCollectionLayout: ChooseIconCollectionLayout? {
        chooseIconView.collectionView.collectionViewLayout as? ChooseIconCollectionLayout
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        chooseIconView.collectionView.delegate = presenter.tableManager
        chooseIconView.collectionView.dataSource = presenter.tableManager

        setupCancelButton()
        setupChooseIconView()

        presenter.viewDidLoad(self)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        presenter.viewWillLayoutSubviews(self)
    }

}

// MARK: - Private
private extension ChooseIconViewController {

    func setupCancelButton() {
        view.addSubview(cancelButton)
        cancelButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-8)
            $0.height.equalTo(57)
        }
    }

    func setupChooseIconView() {
        view.addSubview(chooseIconView)
        chooseIconView.snp.makeConstraints {
            $0.top.greaterThanOrEqualToSuperview().offset(8)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.bottom.equalTo(cancelButton.snp.top).offset(-8)
            $0.height.equalTo(1) // Because needs to be updated
        }
    }

    @objc func closeViewController() {
        dismiss(animated: true)
    }

}

// MARK: - ChooseIconViewInput
extension ChooseIconViewController: ChooseIconViewInput {

    func reloadCollectionViewLayout() {
        chooseIconCollectionLayout?.containerWidth = chooseIconView.bounds.size.width
    }

    func updateIconViewHeight() {
        guard let height = chooseIconCollectionLayout?.containerHeight else { return }
        chooseIconView.snp.updateConstraints {
            $0.height.equalTo(height + 8 + 8)
        }
    }

}
