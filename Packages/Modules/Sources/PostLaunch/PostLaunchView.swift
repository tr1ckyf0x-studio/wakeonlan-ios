//
//  PostLaunchView.swift
//
//
//  Created by Dmitry Stavitsky on 17.09.2022.
//

import SnapKit
import UIKit
import WOLResources

final class PostLaunchView: UIView {
    // MARK: - Appearance

    private let appearance = Appearance(); struct Appearance {
        /// Application main logo
        let logoImage = Asset.Assets.owl.image
    }

    // MARK: - Properties

    /// - NOTE: - It is awful solution as image does not change according to the current color scheme.
    // TODO: Fix it in the next release/commit/PR
    private lazy var logoImageView: UIImageView = {
        $0.image = appearance.logoImage
        return $0
    }(UIImageView())

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Asset.Colors.primary.color
        addSubviews()
        addConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods

private extension PostLaunchView {
    func addSubviews() {
        addSubview(logoImageView)
    }

    func addConstraints() {
        logoImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
