//
//  NotificationView.swift
//  Wake on LAN
//
//  Created by Dmitry on 15.11.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit
import WOLResources

protocol NotificationViewStyle {

    static var text: String { get }
    static var backgroundColor: UIColor { get }

}

enum NotificationViewType {

    struct Default: NotificationViewStyle {
        static let text = WOLResources.L10n.HostList.packetSent
        static let backgroundColor = WOLResources.Asset.Colors.lightGray.color
    }

    struct Failure: NotificationViewStyle {
        static let text = WOLResources.L10n.HostList.checkWifiConnection
        static let backgroundColor = WOLResources.Asset.Colors.red.color
    }

}

final class HostListNotificationView<Style: NotificationViewStyle>: UIView {

    // MARK: - Properties

    private let appearance = Appearance(); struct Appearance {
        let shadowSize: CGFloat = 2
        let shadowDistance: CGFloat = 1
        let shadowRadius: CGFloat = 5
        let shadowOpacity: Float = 0.6
        let cornerRadius: CGFloat = 10
        let shadowHeight: CGFloat = 20.0
    }

    private let style = Style.self

    private lazy var notificationLabel: UILabel = {
        let label = UILabel()
        label.text = style.text
        label.textColor = WOLResources.Asset.Colors.white.color
        label.textAlignment = .center
        label.backgroundColor = style.backgroundColor
        label.font = WOLResources.FontFamily.Roboto.medium.font(size: 12)

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

    override func layoutSubviews() {
        super.layoutSubviews()
        makeShadow()
    }

}

// MARK: - Private

private extension HostListNotificationView {

    func setupBaseView() {
        alpha = .zero
        layer.cornerRadius = 10
        layer.masksToBounds = false
        backgroundColor = style.backgroundColor
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }

    func setupNotificationLabel() {
        addSubview(notificationLabel)
        notificationLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(10)
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview()
        }
    }

    func makeShadow() {
        let xPosition = -(appearance.cornerRadius + appearance.shadowSize * 2)
        let yPosition = appearance.shadowHeight - (appearance.shadowSize * 0.4) + appearance.shadowDistance
        let labelWidth = frame.width
        let width = [labelWidth,
                     appearance.shadowSize * 2,
                     appearance.cornerRadius].reduce(.zero, +)
        let contactRect =
            CGRect(x: xPosition, y: yPosition, width: width, height: appearance.shadowSize)
        notificationLabel.layer.shadowPath = UIBezierPath(ovalIn: contactRect).cgPath
        notificationLabel.layer.shadowRadius = appearance.shadowRadius
        notificationLabel.layer.shadowOpacity = appearance.shadowOpacity
        notificationLabel.layer.masksToBounds = false
    }

}
