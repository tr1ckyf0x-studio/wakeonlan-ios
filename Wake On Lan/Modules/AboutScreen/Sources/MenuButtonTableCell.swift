//
//  MenuButtonTableCell.swift
//  AboutScreen
//
//  Created by Vladislav Lisianskii on 23.05.2021.
//  Copyright © 2021 Владислав Лисянский. All rights reserved.
//

import SnapKit
import UIKit
import WOLResources
import WOLUIComponents

final class MenuButtonTableCell: UITableViewCell {

    // MARK: - Properties

    private lazy var buttonBodyView: SoftUIView = {
        let view = SoftUIView()
        view.configure(with: SoftUIViewModel(contentView: buttonTitleLabel))
        view.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return view
    }()

    private lazy var buttonTitleLabel: UILabel = {
        let label = UILabel()
        label.font = WOLResources.FontFamily.Roboto.bold.font(size: 14)
        label.textColor = WOLResources.Asset.Colors.lightGray.color
        return label
    }()

    private var action: (() -> Void)?

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = WOLResources.Asset.Colors.soft.color
        addSubviews()
        makeConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Override

    override func prepareForReuse() {
        super.prepareForReuse()
        action = nil
    }
}

// MARK: - Internal methods

extension MenuButtonTableCell {
    func configure(with model: MenuButtonCellViewModel) {
        buttonTitleLabel.text = model.title
        self.action = model.action
    }
}

// MARK: - Private methods

private extension MenuButtonTableCell {
    func addSubviews() {
        contentView.addSubview(buttonBodyView)
    }

    func makeConstraints() {
        buttonBodyView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(8)
        }

        buttonTitleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }

    @objc func buttonPressed() {
        action?()
    }
}
