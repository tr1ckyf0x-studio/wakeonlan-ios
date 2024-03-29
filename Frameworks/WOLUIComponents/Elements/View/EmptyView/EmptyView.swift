//
//  TableEmptyView.swift
//  Wake on LAN
//
//  Created by Vladislav Lisianskii on 12.11.2020.
//  Copyright © 2020 Vladislav Lisianskii. All rights reserved.
//

import UIKit
import WOLResources

public final class EmptyView: UIView {

    private lazy var containerView = UIView()

    private lazy var imageView = UIImageView(image: Asset.Assets.owl.image)

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Asset.Colors.secondary.color
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0

        return label
    }()

    // MARK: - Init

    override public init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods

private extension EmptyView {
    func setupView() {
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.top.greaterThanOrEqualToSuperview().offset(16)
        }

        containerView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview()
            make.top.equalToSuperview()
            make.width.equalTo(imageView.snp.height)
            make.width.equalToSuperview().multipliedBy(0.5)
        }

        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - ConfigurableStateView

extension EmptyView: DisplaysStateView {
    public func configure(with viewModel: StateableViewModel) {
        titleLabel.text = viewModel.title
        imageView.image = viewModel.image
        backgroundColor = viewModel.backgroundColor
    }
}
