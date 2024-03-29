//
//  DeviceIconCell.swift
//  Wake on LAN
//
//  Created by Dmitry Stavitsky on 27.05.2020.
//  Copyright © 2020 Vladislav Lisianskii. All rights reserved.
//

import SharedProtocolsAndModels
import UIKit
import WOLResources

final class DeviceIconCell: UITableViewCell {

    typealias ChangeIconBlock = (_ model: IconModel) -> Void

    var didTapChangeIconBlock: ChangeIconBlock?

    private lazy var baseView: DeviceIconView = {
        let view = DeviceIconView()
        view.delegate = self

        return view
    }()

    private let changeIconLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = Asset.Colors.secondaryVariant.color
        label.font = .systemFont(ofSize: 12)
        label.text = L10n.AddHost.Form.Field.ChangeIcon.title

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

    func configure(with model: IconModel?) {
        guard let model else { return }
        self.model = model
        baseView.configure(with: model)
    }
}

// MARK: - Private methods

private extension DeviceIconCell {
    func setupDeviceIconView() {
        contentView.addSubview(baseView)
        baseView.snp.makeConstraints {
            // TODO: Add offset after implementing custom header/footer views
            $0.top.equalTo(contentView.snp.top) // .offset(16)
            $0.height.equalTo(120)
            $0.leading.trailing.equalToSuperview()
        }
    }

    func setupChangeIconLabel() {
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
        guard let model else { return }
        didTapChangeIconBlock?(model)
    }
}
