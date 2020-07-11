//
//  HostListTableViewCell.swift
//  Wake on LAN
//
//  Created by Dmitry on 07.07.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit

class HostListTableViewCell: UITableViewCell {

    // MARK: - Properties
    private let baseView = SoftUIView()

    private let deviceImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .lightGray

        return imageView
    }()

    private let hostTitle: UILabel = {
        let label = UILabel()
        label.font = R.font.robotoLight(size: 18)
        label.textColor = .gray
        label.numberOfLines = 1
        label.textAlignment = .left

        return label
    }()
    
    private let macAddressTitle: UILabel = {
        let label = UILabel()
        label.font = R.font.robotoThin(size: 14)
        label.textColor = .darkGray
        label.numberOfLines = 1
        label.textAlignment = .left
        
        return label
    }()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .softUIColor
        setupBaseView()
        setupImageView()
        setupHostTitle()
        setupMacAddressTitle()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public
    func configure(with model: Host) {
        let image = UIImage(named: model.iconName,
                            in: Bundle.main,
                            compatibleWith: nil)?
            .withRenderingMode(.alwaysTemplate)
        deviceImageView.image = image
        hostTitle.text = model.title
        macAddressTitle.text = model.macAddress
    }

    // MARK: - Private
    private func setupBaseView() {
        contentView.addSubview(baseView)
        baseView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-8)
        }
    }

    private func setupImageView() {
        baseView.addSubview(deviceImageView)
        deviceImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(16)
            $0.trailing.lessThanOrEqualToSuperview().inset(16).priority(.low)
            $0.bottom.equalToSuperview().offset(-16)
            $0.width.height.equalTo(80)
        }
    }
    
    private func setupHostTitle() {
        baseView.addSubview(hostTitle)
        hostTitle.snp.makeConstraints {
            $0.leading.equalTo(deviceImageView.snp.trailing).offset(16)
            $0.top.equalToSuperview().offset(32)
        }
    }
    
    private func setupMacAddressTitle() {
        baseView.addSubview(macAddressTitle)
        macAddressTitle.snp.makeConstraints {
            $0.leading.equalTo(hostTitle.snp.leading)
            $0.top.equalTo(hostTitle.snp.bottom).offset(8)
        }
    }

}
