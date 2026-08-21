//
//  ChooseIconViewController.swift
//  Wake on LAN
//
//  Created by Dmitry Stavitsky on 28.05.2020.
//  Copyright © 2020 Vladislav Lisianskii. All rights reserved.
//

import SnapKit
import UIKit

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

    var presenter: ChooseIconViewOutput?

    private var heightConstraint: Constraint?

    private lazy var chooseIconView: ChooseIconView = {
        let view = ChooseIconView(frame: .zero)
        view.layer.cornerRadius = appearance.cornerRadius

        return view
    }()

    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(L10n.AddHost.Form.ActionSheet.cancel, for: .normal)
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

    override public func viewDidLoad() {
        super.viewDidLoad()
        chooseIconView.collectionView.delegate = presenter?.tableManager
        chooseIconView.collectionView.dataSource = presenter?.tableManager

        setupCancelButton()
        setupChooseIconView()

        presenter?.viewDidLoad(self)
    }

    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        presenter?.viewWillLayoutSubviews(self)
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
        // NOTE: The constraint is created once, on the first real measurement, and only updated
        // afterwards. Creating it on every pass stacked active height constraints on a live view;
        // creating it up front with a height of zero contradicted the collection view pinned inside
        // with 8pt insets, so the very first layout pass logged "Unable to simultaneously satisfy
        // constraints" and UIKit broke one of them.
        let value = height + appearance.chooseIconViewEdgeMargin * 2
        guard let heightConstraint else {
            chooseIconView.snp.makeConstraints {
                heightConstraint = $0.height.equalTo(value).constraint
            }
            return
        }
        heightConstraint.update(offset: value)
    }
}
