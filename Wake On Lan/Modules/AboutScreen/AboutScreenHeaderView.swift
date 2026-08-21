//
//  AboutHeaderTableCell.swift
//  AboutScreen
//
//  Created by Vladislav Lisianskii on 24.04.2021.
//  Copyright © 2021 Vladislav Lisianskii. All rights reserved.
//

import SharedProtocolsAndModels
import UIKit
import WOLSharedProtocolsAndModels

final class AboutScreenHeaderView: UIView {
    // MARK: - Appearance

    private let appearance = Appearance(); struct Appearance {
        /// Application name font
        let appNameFont: UIFont = .systemFont(ofSize: 36, weight: .medium)
        /// Application name text color
        let appNameTextColor = Asset.Colors.secondaryVariant.color
        /// Application version
        let appVersionFont: UIFont = .systemFont(ofSize: 12, weight: .medium)
        /// Application text color
        let appVersionTextColor = Asset.Colors.secondary.color
        /// Application main logo
        let logoImage = Asset.Assets.Logo.owl.image
        /// Spacing between elements in stack
        let stackSpacing: CGFloat = 8.0
        /// Application version (just text)
        let appVersion = L10n.AboutScreen.Item.version
    }

    // MARK: - Properties

    // Contains logo, app name and version
    private lazy var headerStackView: UIStackView = { stackView in
        stackView.addArrangedSubview(logoImageView)
        stackView.addArrangedSubview(appNameLabel)
        stackView.addArrangedSubview(appVersionLabel)
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = appearance.stackSpacing
        return stackView
    }(UIStackView())

    private lazy var logoImageView: UIImageView = {
        $0.image = appearance.logoImage
        return $0
    }(UIImageView())

    private lazy var appNameLabel: UILabel = {
        $0.font = appearance.appNameFont
        $0.textColor = appearance.appNameTextColor
        return $0
    }(UILabel())

    private lazy var appVersionLabel: UILabel = {
        $0.font = appearance.appVersionFont
        $0.textColor = appearance.appVersionTextColor
        return $0
    }(UILabel())

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        addSubviews()
        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AboutScreenHeaderView: ViewModelConfigurable {
    func configure(with viewModel: AboutScreenHeaderViewViewModel) {
        appNameLabel.text = viewModel.name
        appVersionLabel.text = "\(appearance.appVersion) \(viewModel.version)"
    }
}

// MARK: - Private methods

private extension AboutScreenHeaderView {
    func setupView() {
        tintColor = Asset.Colors.primary.color
    }

    func addSubviews() {
        addSubview(logoImageView)
        addSubview(headerStackView)
    }

    func makeConstraints() {
        logoImageView.snp.makeConstraints { make in
            make.width.equalTo(logoImageView.snp.height)
        }

        headerStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
