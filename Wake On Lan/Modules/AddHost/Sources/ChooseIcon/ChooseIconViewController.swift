//
//  ChooseIconViewController.swift
//  Wake on LAN
//
//  Created by Dmitry Stavitsky on 28.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit
import WOLResources

public final class ChooseIconViewController: UIViewController {

    private let appearance = Appearance(); struct Appearance {
        let cancelButtonFontSize: CGFloat = 20.0
        let cornerRadius: CGFloat = 15.0
        let cancelButtonEdgeMargin: CGFloat = 16.0
        let cancelButtonHeight: CGFloat = 57.0
        let chooseIconViewEdgeMargin: CGFloat = 16.0
        let chooseIconViewBottomMargin: CGFloat = 8.0
    }

    // MARK: - Properties

    var presenter: ChooseIconViewOutput!

    private lazy var chooseIconView: ChooseIconView = {
        let view = ChooseIconView(frame: .zero)
        view.layer.cornerRadius = appearance.cornerRadius

        return view
    }()

    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(L10n.AddHost.cancel, for: .normal)
        button.backgroundColor = Asset.Colors.primary.color
        button.setTitleColor(Asset.Colors.secondary.color, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: appearance.cancelButtonFontSize)
        button.layer.cornerRadius = appearance.cornerRadius
        button.addTarget(self, action: #selector(closeViewController), for: .touchUpInside)

        return button
    }()

    private var chooseIconCollectionLayout: ChooseIconCollectionLayout? {
        chooseIconView.collectionView.collectionViewLayout as? ChooseIconCollectionLayout
    }

    // MARK: - Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        chooseIconView.collectionView.delegate = presenter.tableManager
        chooseIconView.collectionView.dataSource = presenter.tableManager

        setupCancelButton()
        setupChooseIconView()

        presenter.viewDidLoad(self)
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        presenter.viewWillLayoutSubviews(self)
    }

}

// MARK: - Private

private extension ChooseIconViewController {

    func setupCancelButton() {
        view.addSubview(cancelButton)
        cancelButton.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview().inset(appearance.cancelButtonEdgeMargin)
            $0.height.equalTo(appearance.cancelButtonHeight)
        }
    }

    func setupChooseIconView() {
        view.addSubview(chooseIconView)
        chooseIconView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(appearance.chooseIconViewEdgeMargin)
            $0.top.greaterThanOrEqualToSuperview()
            $0.trailing.equalToSuperview().inset(appearance.chooseIconViewEdgeMargin)
            $0.bottom.equalTo(cancelButton.snp.top).offset(-appearance.chooseIconViewBottomMargin)
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
        guard
            let height = chooseIconCollectionLayout?.containerHeight,
            height > .zero
        else {
            return
        }
        chooseIconView.snp.makeConstraints {
            $0.height.equalTo(height + appearance.chooseIconViewEdgeMargin * 2)
        }
    }

}
