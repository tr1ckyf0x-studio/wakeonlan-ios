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
    func configure(with viewModel: AboutScreenViewViewModel)
}

final class AboutScreenView: UIView {

    // MARK: - Appearance

    private let appearance = Appearance(); struct Appearance {
        let backBarButtonSize: CGFloat = 32.0
        let backBarButtonImageViewInset: CGFloat = 6.0
        let backBarButtonTintColor = Asset.Colors.lightGray.color
        let backBarButtonImage = UIImage(
            sfSymbol: ButtonIcon.chevronBackward,
            withConfiguration: .init(weight: .semibold)
        )

        let stackSpacing: CGFloat = 16.0
        let stackViewTopOffset: CGFloat = 24.0
        let stackButtonHeight: CGFloat = 48.0
        let leadingStackOffset: CGFloat = 16.0
        let trailingStackInset: CGFloat = 16.0
    }

    // MARK: - Properties

    weak var delegate: AboutScreenViewDelegate?

    lazy var backBarButton: UIBarButtonItem = {
        let imageView = UIImageView(image: appearance.backBarButtonImage)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = appearance.backBarButtonTintColor
        let button = SoftUIView(circleShape: true)
        button.configure(with: SoftUIViewModel(contentView: imageView))
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(appearance.backBarButtonImageViewInset)
        }
        button.snp.makeConstraints { make in
            make.size.equalTo(appearance.backBarButtonSize)
        }
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)

        return .init(customView: button)
    }()

    private let baseScrollView = UIScrollView()

    private let contentView = UIView()

    private let headerView = AboutScreenHeaderView()

    private lazy var stackView: UIStackView = {
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.spacing = appearance.stackSpacing
        return $0
    }(UIStackView())

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
    func configure(with viewModel: AboutScreenViewViewModel) {
        // Configure header view
        headerView.configure(with: viewModel.headerViewModel)

        // Configure menu buttons
        viewModel.buttonListViewModel.forEach {
            let buttonView = AboutScreenMenuButtonView()
            buttonView.configure(with: $0)
            buttonView.snp.makeConstraints {
                $0.height.equalTo(appearance.stackButtonHeight)
            }
            stackView.addArrangedSubview(buttonView)
        }
    }
}

// MARK: - Private

private extension AboutScreenView {
    func addSubviews() {
        addSubview(baseScrollView)
        baseScrollView.addSubview(contentView)
        contentView.addSubview(headerView)
        contentView.addSubview(stackView)
    }

    func makeConstraints() {
        baseScrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(self)
        }
        headerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview()
        }
        stackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(appearance.leadingStackOffset)
            $0.top.equalTo(headerView.snp.bottom).offset(appearance.stackViewTopOffset)
            $0.trailing.equalToSuperview().inset(appearance.trailingStackInset)
            $0.bottom.lessThanOrEqualToSuperview()
        }
    }

    @objc func backButtonPressed() {
        delegate?.aboutScreenViewDidPressBackButton(self)
    }
}
