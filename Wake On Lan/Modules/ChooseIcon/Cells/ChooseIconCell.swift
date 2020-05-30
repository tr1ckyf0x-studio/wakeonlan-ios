//
//  IconCell.swift
//  Wake on LAN
//
//  Created by Dmitry Stavitsky on 28.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit

class ChooseIconCell: UICollectionViewCell {

    typealias TapIconBlock = ((_ cell: ChooseIconCell) -> Void)

    public var didTapIconBlock: TapIconBlock?

    private lazy var baseView: DeviceIconView = {
        let view = DeviceIconView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.7).cgColor
        view.layer.cornerRadius = 10
        view.delegate = self

        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDeviceIconView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func configure(with model: IconModel) {
        baseView.configure(with: model)
    }

    private func setupDeviceIconView() {
        contentView.addSubview(baseView)
        baseView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

}

extension ChooseIconCell: DeviceIconViewDelegate {
    func didTapChangeIcon(_ view: DeviceIconView) {
        guard let block = didTapIconBlock else { return }
        block(self)
    }
}
