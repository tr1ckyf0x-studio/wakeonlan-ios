//
//  HostListTableViewCell.swift
//  Wake on LAN
//
//  Created by Dmitry on 07.07.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit

// MARK: - HostListTableViewCell
final class HostListTableViewCell: UITableViewCell {

    // MARK: - Properties
    private var model: Host?

    private weak var delegate: HostListTableViewCellDelegate?

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceHorizontal = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self

        return scrollView
    }()

    private let scrollViewContentView = UIView()

    private lazy var deleteButton: SoftUIButton = {
        let button = SoftUIButton(roundShape: false)
        button.setImage(R.image.icon_trash(), for: .normal)
        button.addTarget(self,
                         action: #selector(didTapDeleteButton),
                         for: .touchUpInside)

        return button
    }()

    private lazy var baseView: SoftUIButton = {
        let view = SoftUIButton()
        view.addTarget(self,
                       action: #selector(displayNotification),
                       for: .touchUpInside)

        return view
    }()

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

        return button
    }()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .softUIColor
        setupScrollView()
        setupBaseView()
        setupDeleteView()
        setupImageView()
        setupHostTitle()
        setupMacAddressTitle()
        setupInfoButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public
    func configure(with model: Host, delegate: HostListTableViewCellDelegate?) {
        let image = UIImage(named: model.iconName,
                            in: Bundle.main,
                            compatibleWith: nil)?
            .withRenderingMode(.alwaysTemplate)
        deviceImageView.image = image
        hostTitle.text = model.title
        macAddressTitle.text = model.macAddress
        self.model = model
        self.delegate = delegate
    }

    // MARK: - Private
    private func setupScrollView() {
        contentView.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        scrollView.addSubview(scrollViewContentView)
        scrollViewContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setupBaseView() {
        scrollViewContentView.addSubview(baseView)
        baseView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(8)
            $0.bottom.equalToSuperview().offset(-8)
            $0.width.equalTo(scrollView).offset(-32)
        }
        scrollView.snp.makeConstraints { make in
            make.height.equalTo(baseView).offset(16)
        }
    }

    private func setupDeleteView() {
        scrollViewContentView.addSubview(deleteButton)
        deleteButton.snp.makeConstraints { make in
            make.top.bottom.equalTo(baseView)
            make.leading.equalTo(baseView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.width.equalTo(deleteButton.snp.height)
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
        guard let model = self.model else { return }
        delegate?.hostListCellDidTapInfo(self, model: model)
    }

    @objc private func didTapDeleteButton() {
        guard let model = self.model else { return }
        delegate?.hostListCellDidTapDelete(self, model: model)
    }

    @objc private func displayNotification() {
        let notificationView = NotificationView()
        baseView.addSubview(notificationView)
        notificationView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }

        let animationDuration = 0.2
        let hideNotificationAnimated = { () -> Void in
            UIView.animate(withDuration: animationDuration,
                           animations: { notificationView.alpha = 0.0 },
                           completion: { _ in
                            notificationView.removeFromSuperview()
                           })
        }

        let displayNotificationAnimated = { () -> Void in
            UIView.animate(withDuration: animationDuration,
                           animations: { notificationView.alpha = 1.0 },
                           completion: { _ in
                            DispatchQueue.main.asyncAfter(
                                deadline: .now() + 0.5,
                                execute: {
                                    hideNotificationAnimated()
                                })
                           })
        }

        guard let model = self.model else { return }
        delegate?.hostListCellDidTap(self, model: model)

        UINotificationFeedbackGenerator().notificationOccurred(.success)
        displayNotificationAnimated()
    }

}

// MARK: - UIScrollViewDelegate
extension HostListTableViewCell: UIScrollViewDelegate {

    // NOTE: Prevents left swiping
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        switch scrollView.contentOffset.x {
        case let xOffset where xOffset <= .zero:
            scrollView.isPagingEnabled = false
            scrollView.contentOffset.x = .zero

        default:
            scrollView.isPagingEnabled = true
        }
    }

}

// MARK: - NotificationView
private final class NotificationView: UIView {

    private enum Constants {
        static let shadowSize: CGFloat = 2
        static let shadowDistance: CGFloat = 10
        static let shadowRadius: CGFloat = 5
        static let shadowOpacity: Float = 0.6
        static let cornerRadius: CGFloat = 10
        static let viewHeight: CGFloat = 20
    }

    private lazy var notificationLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.hostList.packetSent()
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = .lightGray
        label.font = R.font.robotoMedium(size: 12)
        makeShadow(for: label)

        return label
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBaseView()
        setupNotificationLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private
    private func setupBaseView() {
        alpha = .zero
        layer.cornerRadius = 10
        layer.masksToBounds = false
        backgroundColor = .lightGray
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }

    private func setupNotificationLabel() {
        addSubview(notificationLabel)
        notificationLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(10)
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview()
        }
    }

    private func makeShadow(for label: UILabel) {
        let xPosition = -(Constants.cornerRadius + Constants.shadowSize * 2)
        let yPosition = Constants.viewHeight - (Constants.shadowSize * 0.4) + Constants.shadowDistance
        let labelWidth = label.intrinsicContentSize.width
        let width = [labelWidth * 2,
                     Constants.shadowSize * 2,
                     Constants.cornerRadius].reduce(.zero, +)

        let contactRect =
            CGRect(x: xPosition, y: yPosition, width: width, height: Constants.shadowSize)

        label.layer.shadowPath = UIBezierPath(ovalIn: contactRect).cgPath
        label.layer.shadowRadius = Constants.shadowRadius
        label.layer.shadowOpacity = Constants.shadowOpacity
        label.layer.masksToBounds = false
    }

    // MARK: - intrinsicContentSize
    override var intrinsicContentSize: CGSize {
        .init(width: notificationLabel.intrinsicContentSize.width * 2,
              height: Constants.viewHeight)
    }

}
