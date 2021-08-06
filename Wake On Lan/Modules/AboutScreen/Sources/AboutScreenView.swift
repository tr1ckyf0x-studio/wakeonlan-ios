//
//  AboutScreenView.swift
//  AboutScreen
//
//  Created by Vladislav Lisianskii on 24.04.2021.
//  Copyright © 2021 Владислав Лисянский. All rights reserved.
//

import SnapKit
import UIKit
import WOLResources
import WOLUIComponents

protocol AboutScreenViewDelegate: AnyObject {
    func aboutScreenViewDidPressBackButton(_ view: AboutScreenView)
}

protocol AboutScreenViewRepresentable {
    func configure(with appName: String, appVersion: String?)
    func configureTableView(with manager: ManagingAboutScreenTable)
    func reloadData()
}

final class AboutScreenView: UIView {

    // MARK: - Appearance

    private let appearance = Appearance(); struct Appearance {
        let barButtonImageViewInset: CGFloat = 6.0
        let backBarButtonImage = UIImage(
            sfSymbol: ButtonIcon.chevronBackward,
            withConfiguration: .init(weight: .semibold)
        )
        let backBarTintColor = Asset.Colors.lightGray.color
        let backBarButtonSize: CGFloat = 32.0
        let tableHeaderSize: CGRect = .init(origin: .zero, size: .init(width: 210, height: 105))
    }

    // MARK: - Properties

    weak var delegate: AboutScreenViewDelegate?

    lazy var backBarButton: UIBarButtonItem = {
        let imageView = UIImageView(image: appearance.backBarButtonImage)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = appearance.backBarTintColor
        let button = SoftUIView(circleShape: true)
        button.configure(with: SoftUIViewModel(contentView: imageView))
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(appearance.barButtonImageViewInset)
        }
        button.snp.makeConstraints { make in
            make.size.equalTo(appearance.backBarButtonSize)
        }
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)

        return .init(customView: button)
    }()

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MenuButtonTableCell.self, forCellReuseIdentifier: "\(MenuButtonTableCell.self)")
        tableView.separatorStyle = .none
        tableView.backgroundColor = Asset.Colors.soft.color
        tableView.tableHeaderView = self.tableHeaderView

        return tableView
    }()

    private lazy var tableHeaderView = AboutHeaderTableView(frame: appearance.tableHeaderSize)

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Asset.Colors.soft.color
        addSubviews()
        makeConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - AboutScreenViewRepresentable

extension AboutScreenView: AboutScreenViewRepresentable {

    func reloadData() {
        tableView.reloadData()
    }

    func configureTableView(with manager: ManagingAboutScreenTable) {
        tableView.dataSource = manager
        tableView.delegate = manager
    }

    func configure(with appName: String, appVersion: String?) {
        tableHeaderView.configure(appName: appName, appVersion: appVersion)
    }

}

// MARK: - Private

private extension AboutScreenView {

    func addSubviews() {
        addSubview(tableView)
    }

    func makeConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    @objc func backButtonPressed() {
        delegate?.aboutScreenViewDidPressBackButton(self)
    }
}
