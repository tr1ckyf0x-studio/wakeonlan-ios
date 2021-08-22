//
//  IconCell.swift
//  Wake on LAN
//
//  Created by Dmitry Stavitsky on 28.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import SharedModels
import UIKit
import WOLResources
import WOLUIComponents

final class ChooseIconCell: UICollectionViewCell {

    typealias TapIconBlock = (_ cell: ChooseIconCell) -> Void

    // MARK: - Properties

    private var didTapIconBlock: TapIconBlock?

    private lazy var deviceButton: SoftUIView = {
        let button = SoftUIView()
        button.addTarget(self, action: #selector(didTapDeviceButton(_:)), for: .touchUpInside)

        return button
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDeviceIconView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public

    func configure(with model: IconModel, didTapBlock: @escaping TapIconBlock) {
        didTapIconBlock = didTapBlock
        setupDeviceImage(with: model.sfSymbol)
    }

    // MARK: - Private

    private func setupDeviceImage(with sfSymbol: SFSymbolRepresentable) {
        let image = UIImage(sfSymbol: sfSymbol)
        let imageView = UIImageView(image: image)
        imageView.tintColor = Asset.Colors.secondaryVariant.color
        imageView.contentMode = .scaleAspectFit
        deviceButton.configure(with: SoftUIViewModel(contentView: imageView))
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(6)
        }
    }

    private func setupDeviceIconView() {
        contentView.addSubview(deviceButton)
        deviceButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    // MARK: - Action

    @objc private func didTapDeviceButton(_ sender: UIButton) {
        didTapIconBlock?(self)
    }

}
