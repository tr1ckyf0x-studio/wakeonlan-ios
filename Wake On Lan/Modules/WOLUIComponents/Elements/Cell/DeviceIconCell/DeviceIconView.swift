//
//  DeviceIconCellView.swift
//  Wake on LAN
//
//  Created by Dmitry Stavitsky on 28.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit
import WOLResources

protocol DeviceIconViewDelegate: AnyObject {
    func deviceIconViewDidTapChangeIcon(_ view: DeviceIconView)
}

final class DeviceIconView: UIView {

    // MARK: - Properties

    weak var delegate: DeviceIconViewDelegate?

    private lazy var deviceImageView: UIImageView = {
        let image = R.image.desktop()?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        imageView.layer.cornerRadius = 14
        imageView.tintColor = R.color.lightGray()
        imageView.isUserInteractionEnabled = true

        // Add tap gesture recognizer
        imageView.addGestureRecognizer({
            UITapGestureRecognizer(target: self, action: #selector(didTapChangeIcon))
            }())

        return imageView
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupDeviceImageView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: IconModel) {
        deviceImageView.image = UIImage(
            named: model.pictureName
        )?.withRenderingMode(.alwaysTemplate)
    }

    // MARK: - Private

    private func setupDeviceImageView() {
        addSubview(deviceImageView)
        deviceImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.width.equalTo(deviceImageView.snp.height)
        }
    }

    // MARK: - Action

    @objc private func didTapChangeIcon() {
        delegate?.deviceIconViewDidTapChangeIcon(self)
    }

}
