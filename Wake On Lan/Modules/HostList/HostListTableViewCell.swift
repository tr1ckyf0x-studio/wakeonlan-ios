//
//  HostListTableViewCell.swift
//  Wake on LAN
//
//  Created by Dmitry on 07.07.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit

class HostListTableViewCell: UITableViewCell {

    typealias TapInfoBlock = (_ cell: HostListTableViewCell) -> Void

    // MARK: - Properties
    private let baseView = SoftUIView()
    
    private var didTapInfoBlock: TapInfoBlock?

    private let deviceImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .lightGray

        return imageView
    }()

    private let hostTitle: UILabel = {
        let label = UILabel()
        label.font = R.font.robotoMedium(size: 18)
        label.textColor = .gray
        label.numberOfLines = 1
        label.textAlignment = .left

        return label
    }()
    
    private let macAddressTitle: UILabel = {
        let label = UILabel()
        label.font = R.font.robotoLight(size: 14)
        label.textColor = .darkGray
        label.numberOfLines = 1
        label.textAlignment = .left
        
        return label
    }()
    
    private lazy var infoButton: SoftUIButton = {
        let button = SoftUIButton(roundShape: true)
        button.setImage(R.image.more(), for: .normal)
        button.addTarget(self, action: #selector(didTapInfoButton), for: .touchUpInside)
        button.adjustsImageWhenDisabled = false
        button.adjustsImageWhenHighlighted = false

        return button
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
        setupInfoButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public
    func configure(with model: Host, didTapInfoBlock: @escaping TapInfoBlock) {
        let image = UIImage(named: model.iconName,
                            in: Bundle.main,
                            compatibleWith: nil)?
            .withRenderingMode(.alwaysTemplate)
        deviceImageView.image = image
        hostTitle.text = model.title
        macAddressTitle.text = model.macAddress
        self.didTapInfoBlock = didTapInfoBlock
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
    
    private func setupInfoButton() {
        baseView.addSubview(infoButton)
        infoButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.top.equalToSuperview().offset(36)
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(36)
            $0.height.equalTo(infoButton.snp.width)
        }
    }
    
    // MARK: - Action
    @objc private func didTapInfoButton() {
        guard let action = didTapInfoBlock else { return }
        action(self)
    }

}
