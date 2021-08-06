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

final class AboutHeaderTableView: UITableViewHeaderFooterView {

    // MARK: - Properties

    private lazy var logoImageView: UIImageView = {
        let image = Asset.Assets.owl.image
        let imageView = UIImageView(image: image)
        return imageView
    }()

    private lazy var appNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 36, weight: .medium)
        label.textColor = Asset.Colors.gray900.color
        return label
    }()

    private lazy var appVersionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = Asset.Colors.gray.color
        return label
    }()

    // MARK: - Init

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
        addSubviews()
        makeConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AboutHeaderTableView {
    func configure(appName: String, appVersion: String?) {
        appNameLabel.text = appName
        appVersionLabel.text = "\(L10n.AboutScreen.version) \(appVersion ?? .empty)"
    }
}

// MARK: - Private methods

private extension AboutHeaderTableView {

    func setupView() {
        tintColor = Asset.Colors.soft.color
    }

    func addSubviews() {
        addSubview(logoImageView)
        addSubview(appNameLabel)
        addSubview(appVersionLabel)
    }

    func makeConstraints() {
        logoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalTo(logoImageView.snp.height)
            make.width.equalToSuperview().multipliedBy(0.4)
        }

        appNameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(logoImageView.snp.bottom).offset(16)
        }

        appVersionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(appNameLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview().inset(16)
        }
    }
}
