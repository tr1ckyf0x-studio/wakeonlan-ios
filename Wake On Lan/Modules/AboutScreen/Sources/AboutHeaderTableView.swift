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

final class AboutHeaderTableView: UIView {

    // MARK: - Properties

    private lazy var appNameLabel: UILabel = {
        let label = UILabel()
        label.font = FontFamily.Roboto.medium.font(size: 36)
        label.textColor = Asset.Colors.gray900.color
        return label
    }()

    private lazy var appVersionLabel: UILabel = {
        let label = UILabel()
        label.font = FontFamily.Roboto.medium.font(size: 12)
        label.textColor = Asset.Colors.gray.color
        return label
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
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

    func addSubviews() {
        addSubview(appNameLabel)
        addSubview(appVersionLabel)
    }

    func makeConstraints() {
        appNameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(16)
        }

        appVersionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(appNameLabel.snp.bottom).offset(8)
        }
    }
}
