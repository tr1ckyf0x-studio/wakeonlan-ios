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
    static var textColor: UIColor { get }
}

enum NotificationViewType {
    struct Default: NotificationViewStyle {
        static let text = L10n.HostList.Notification.packetSent
        static let backgroundColor = Asset.Colors.secondary.color
        static let textColor = Asset.Colors.primary.color
    }

    struct Failure: NotificationViewStyle {
        static let text = L10n.HostList.Notification.checkConnection
        static let backgroundColor = Asset.Colors.warning.color
        static let textColor = Asset.Colors.secondaryVariant.color.resolvedColor(
            with: .init(userInterfaceStyle: .dark)
        )
    }
}

final class HostListNotificationView<Style: NotificationViewStyle>: UIView {

    // MARK: - Properties

    private let appearance = Appearance(); struct Appearance {
        let cornerRadius: CGFloat = 10
    }

    private let style = Style.self

    private lazy var notificationLabel: UILabel = {
        let label = UILabel()
        label.text = style.text
        label.textColor = style.textColor
        label.textAlignment = .center
        label.backgroundColor = style.backgroundColor
        label.font = .systemFont(ofSize: 12, weight: .medium)

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

}
