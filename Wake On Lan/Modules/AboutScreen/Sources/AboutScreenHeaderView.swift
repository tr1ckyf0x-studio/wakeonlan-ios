//
//  AboutHeaderTableCell.swift
//  AboutScreen
//
//  Created by Vladislav Lisianskii on 24.04.2021.
//  Copyright © 2021 Владислав Лисянский. All rights reserved.
//

import SnapKit
import UIKit
import WOLResources

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
        let logoImage = Asset.Assets.owl.image
        /// Spacing between elements in stack
        let stackSpacing: CGFloat = 8.0
        /// Application version (just text)
        let appVersion = L10n.AboutScreen.version
    }

    // MARK: - Properties

    // Contains logo, app name and version
    private lazy var headerStackView: UIStackView = {
        $0.addArrangedSubview(logoImageView)
        $0.addArrangedSubview(appNameLabel)
        $0.addArrangedSubview(appVersionLabel)
        $0.axis = .vertical
        $0.alignment = .center
        $0.distribution = .fillProportionally
        $0.spacing = appearance.stackSpacing
        return $0
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

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AboutScreenHeaderView {
    func configure(with viewModel: AboutScreenHeaderViewViewModel) {
        appNameLabel.text = viewModel.name
        let versionText = "\(viewModel.version) \(L10n.AboutScreen.build) \(viewModel.build)"
        appVersionLabel.text = "\(appearance.appVersion) \(versionText)"
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
