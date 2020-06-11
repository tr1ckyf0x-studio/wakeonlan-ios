//
//  DeviceIconCell.swift
//  Wake on LAN
//
//  Created by Dmitry Stavitsky on 27.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit
import SnapKit

class DeviceIconCell: UITableViewCell {

    typealias ChangeIconBlock = (_ model: IconModel) -> Void

    public var didTapChangeIconBlock: ChangeIconBlock?

    private lazy var baseView: DeviceIconView = {
        let view = DeviceIconView()
        view.delegate = self

        return view
    }()

    private let changeIconLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = .gray
        label.font = .systemFont(ofSize: 12)
        label.text = R.string.addHost.changeIcon()

        return label
    }()

    private var model: IconModel?

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        setupDeviceIconView()
        setupChangeIconLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public
    public func configure(with model: IconModel) {
        self.model = model
        baseView.configure(with: model)
    }

    // MARK: - Private
    private func setupDeviceIconView() {
        contentView.addSubview(baseView)
        baseView.snp.makeConstraints {
            // TODO: Add offset after implementing custom header/footer views
            $0.top.equalTo(contentView.snp.top) // .offset(16)
            $0.height.equalTo(120)
            $0.leading.trailing.equalToSuperview()
        }
    }

    private func setupChangeIconLabel() {
        contentView.addSubview(changeIconLabel)
        changeIconLabel.snp.makeConstraints {
            $0.top.equalTo(baseView.snp.bottom).offset(8)
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
    }

}

// MARK: - DeviceIconViewDelegate
extension DeviceIconCell: DeviceIconViewDelegate {
    func deviceIconViewDidTapChangeIcon(_ view: DeviceIconView) {
        guard let model = self.model else { return }
        didTapChangeIconBlock?(model)
    }
}
