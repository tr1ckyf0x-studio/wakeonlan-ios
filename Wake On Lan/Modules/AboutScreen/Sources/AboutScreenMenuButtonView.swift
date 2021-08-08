//
//  AboutScreenMenuButtonView.swift
//  AboutScreen
//
//  Created by Vladislav Lisianskii on 23.05.2021.
//  Copyright © 2021 Владислав Лисянский. All rights reserved.
//

import SnapKit
import UIKit
import WOLResources
import WOLUIComponents

final class AboutScreenMenuButtonView: UIView {

    // MARK: - Appearance

    private let appearance = Appearance(); struct Appearance {
        let buttonBodyViewLeadingTrailingOffset: CGFloat = 16.0
        let buttonBodyViewTopBottomOffset: CGFloat = 8.0
        let buttonContentViewEdgesInset: CGFloat = 8.0
        let buttonTitleLabelLeadingOffset: CGFloat = 8.0
    }

    // MARK: - Properties

    private lazy var buttonBodyView: SoftUIView = {
        let view = SoftUIView()
        view.configure(with: SoftUIViewModel(contentView: buttonContentView))
        view.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return view
    }()

    private lazy var buttonContentView: UIView = {
        let view = UIView()
        view.addSubview(buttonImageView)
        view.addSubview(buttonTitleLabel)
        return view
    }()

    private lazy var buttonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = Asset.Colors.lightGray.color
        return imageView
    }()

    private lazy var buttonTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = Asset.Colors.lightGray.color
        return label
    }()

    private var action: (() -> Void)?

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

// MARK: - Internal methods

extension AboutScreenMenuButtonView {
    func configure(with model: AboutScreenMenuButtonViewViewModel) {
        action = model.action
        buttonTitleLabel.text = model.title
        buttonImageView.image = UIImage(sfSymbol: model.symbol, withConfiguration: .init(weight: .semibold))
    }
}

// MARK: - Private methods

private extension AboutScreenMenuButtonView {
    func addSubviews() {
        addSubview(buttonBodyView)
    }

    func makeConstraints() {
        buttonBodyView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(appearance.buttonBodyViewLeadingTrailingOffset)
            make.top.equalToSuperview().offset(appearance.buttonBodyViewTopBottomOffset)
            make.trailing.equalToSuperview().inset(appearance.buttonBodyViewLeadingTrailingOffset)
            make.bottom.equalToSuperview().inset(appearance.buttonBodyViewTopBottomOffset)
        }

        buttonContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(appearance.buttonContentViewEdgesInset)
        }

        buttonImageView.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
        }

        buttonTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(buttonImageView.snp.trailing).offset(appearance.buttonTitleLabelLeadingOffset)
            make.top.bottom.trailing.equalToSuperview()
        }

        buttonImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }

    @objc func buttonPressed() {
        action?()
    }
}
