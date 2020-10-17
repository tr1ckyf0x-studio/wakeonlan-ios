//
//  IconCell.swift
//  Wake on LAN
//
//  Created by Dmitry Stavitsky on 28.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit

class ChooseIconCell: UICollectionViewCell {

    typealias TapIconBlock = (_ cell: ChooseIconCell) -> Void

    // MARK: - Properties
    private var didTapIconBlock: TapIconBlock?

    private lazy var deviceButton: SoftUIButton = {
        let button = SoftUIButton()
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
        setupDeviceImage(with: model.pictureName)
    }

    // MARK: - Private
    private func setupDeviceImage(with imageName: String) {
        let image = UIImage(named: imageName,
                            in: Bundle.main,
                            compatibleWith: nil)?
            .withRenderingMode(.alwaysTemplate)
        deviceButton.setImage(image, for: .normal)
        deviceButton.imageView?.tintColor = .systemGray
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
