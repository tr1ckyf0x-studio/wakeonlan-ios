//
//  TableEmptyView.swift
//  Wake on LAN
//
//  Created by Владислав Лисянский on 12.11.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit
import SnapKit

class TableEmptyView: UIView {

    private lazy var containerView = UIView()

    private lazy var imageView = UIImageView(image: R.image.droids())

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.tableEmptyView.emptyViewMessage()
        label.textColor = R.color.lightGray()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Private methods

private extension TableEmptyView {
    func setupView() {
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.top.greaterThanOrEqualToSuperview().offset(8)
        }

        containerView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview()
            make.top.equalToSuperview()
            make.width.equalTo(imageView.snp.height).multipliedBy(612.0 / 726.0)
            make.width.equalToSuperview().multipliedBy(0.5)
        }

        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - ConfigurableStateView

extension TableEmptyView: DisplaysStateView {
    func configure(with viewModel: StateableViewModel) {
        titleLabel.text = viewModel.title
        imageView.image = viewModel.image
        backgroundColor = viewModel.backgroundColor
    }

}
