//
//  AboutScreenView.swift
//  AboutScreen
//
//  Created by Vladislav Lisianskii on 24.04.2021.
//  Copyright © 2021 Владислав Лисянский. All rights reserved.
//

import SnapKit
import UIKit
import WOLUIComponents
import WOLResources

protocol AboutScreenViewDelegate: AnyObject {
    func aboutScreenViewDidPressBackButton(_ view: AboutScreenView)
}

final class AboutScreenView: UIView {

    // MARK: - Appearance

    private let appearance = Appearance(); struct Appearance {
        let barButtonImageViewInset: CGFloat = 6.0
        let backBarButtonImage = UIImage(sfSymbol: .chevronBackward, withConfiguration: .init(weight: .semibold))
        let backBarTintColor = WOLResources.Asset.Colors.lightGray.color
        let backBarButtonSize: CGFloat = 32.0
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

        return UIBarButtonItem(customView: button)
    }()

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(AboutHeaderTableCell.self, forCellReuseIdentifier: "\(AboutHeaderTableCell.self)")
        tableView.register(MenuButtonTableCell.self, forCellReuseIdentifier: "\(MenuButtonTableCell.self)")
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = WOLResources.Asset.Colors.soft.color
        return tableView
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods
private extension AboutScreenView {

    func setupViews() {
        backgroundColor = WOLResources.Asset.Colors.soft.color
        addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    @objc func backButtonPressed() {
        delegate?.aboutScreenViewDidPressBackButton(self)
    }

}
