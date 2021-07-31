//
//  HostListTableViewCell.swift
//  Wake on LAN
//
//  Created by Dmitry on 07.07.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import CoreDataService
import CocoaLumberjackSwift
import Reachability
import WOLUIComponents
import WOLResources

// MARK: - HostListTableViewCell

final class HostListTableViewCell: UITableViewCell {

    // MARK: - Typealiases

    typealias Default = HostListNotificationView<NotificationViewType.Default>
    typealias Failure = HostListNotificationView<NotificationViewType.Failure>

    // MARK: - Properties

    private var model: Host?

    private weak var delegate: HostListTableViewCellDelegate?

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.alwaysBounceHorizontal = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false

        return scrollView
    }()

    private let scrollViewContentView = UIView()

    private lazy var deleteButton: SoftUIView = {
        let button = SoftUIView()
        let symbolConfiguration = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 36, weight: .regular))
        let image = UIImage(sfSymbol: .trash, withConfiguration: symbolConfiguration)
        let imageView = UIImageView(image: image)
        imageView.tintColor = WOLResources
            .Asset
            .Colors
            .lightGray
            .color
        button.configure(with: SoftUIViewModel(contentView: imageView))
        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        button.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)

        return button
    }()

    private lazy var baseView: SoftUIView = {
        let view = SoftUIView()
        view.type = .normal
        view.addTarget(self, action: #selector(displayNotification), for: .touchUpInside)

        return view
    }()

    private let deviceImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = WOLResources.Asset.Colors.lightGray.color

        return imageView
    }()

    private let hostTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = WOLResources.Asset.Colors.gray.color
        label.numberOfLines = 1
        label.textAlignment = .left

        return label
    }()

    private let macAddressTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.textColor = WOLResources.Asset.Colors.darkGray.color
        label.numberOfLines = 1
        label.textAlignment = .left

        return label
    }()

    private lazy var infoButton: SoftUIView = {
        let button = SoftUIView(circleShape: true)
        let imageConfiguration = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 24, weight: .semibold))
        let image = UIImage(sfSymbol: .ellipsis, withConfiguration: imageConfiguration)
        let imageView = UIImageView(image: image)
        imageView.tintColor = WOLResources
            .Asset
            .Colors
            .lightGray
            .color
        button.configure(with: SoftUIViewModel(contentView: imageView))
        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        button.addTarget(self, action: #selector(didTapInfoButton), for: .touchUpInside)

        return button
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = WOLResources.Asset.Colors.soft.color
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
        let image = Bundle.allBundles.lazy
            .compactMap { bundle in
                UIImage(named: model.iconName, in: bundle, compatibleWith: nil)
            }
            .first?
            .withRenderingMode(.alwaysTemplate)
        hostTitle.text = model.title
        deviceImageView.image = image
        macAddressTitle.text = model.macAddress
        self.model = model
        self.delegate = delegate
    }

}

// MARK: - Private

private extension HostListTableViewCell {

    func setupScrollView() {
        contentView.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        scrollView.addSubview(scrollViewContentView)
        scrollViewContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func setupBaseView() {
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

    func setupDeleteView() {
        scrollViewContentView.addSubview(deleteButton)
        deleteButton.snp.makeConstraints { make in
            make.top.bottom.equalTo(baseView)
            make.leading.equalTo(baseView.snp.trailing).offset(20)
            make.trailing.equalToSuperview().offset(-16)
            make.width.equalTo(deleteButton.snp.height)
        }
    }

    func setupImageView() {
        baseView.addSubview(deviceImageView)
        deviceImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(16)
            $0.trailing.lessThanOrEqualToSuperview().inset(16).priority(.low)
            $0.bottom.equalToSuperview().offset(-16)
            $0.width.height.equalTo(80)
        }
    }

    func setupHostTitle() {
        baseView.addSubview(hostTitle)
        hostTitle.snp.makeConstraints {
            $0.leading.equalTo(deviceImageView.snp.trailing).offset(16)
            $0.top.equalToSuperview().offset(32)
        }
    }

    func setupMacAddressTitle() {
        baseView.addSubview(macAddressTitle)
        macAddressTitle.snp.makeConstraints {
            $0.leading.equalTo(hostTitle.snp.leading)
            $0.top.equalTo(hostTitle.snp.bottom).offset(8)
        }
    }

    func setupInfoButton() {
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

    @objc func didTapInfoButton() {
        guard let model = self.model else { return }
        delegate?.hostListCellDidTapInfo(self, model: model)
    }

    @objc func didTapDeleteButton() {
        guard let model = self.model else { return }
        delegate?.hostListCellDidTapDelete(self, model: model)
    }

    @objc func displayNotification() {
        guard let reachability = try? Reachability() else {
            DDLogWarn("It is impossible to determine the connection type")
            return
        }

        let isReachableViaWiFi = reachability.connection == .wifi
        let notificationView = isReachableViaWiFi ? Default() : Failure()

        baseView.addSubview(notificationView)
        notificationView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(24)
        }

        let animationDuration = 0.2
        let hideNotificationAnimated = { () -> Void in
            UIView.animate(
                withDuration: animationDuration,
                animations: { notificationView.alpha = 0.0 },
                completion: { _ in
                    notificationView.removeFromSuperview()
                }
            )
        }

        let displayNotificationAnimated = { () -> Void in
            UIView.animate(
                withDuration: animationDuration,
                animations: { notificationView.alpha = 1.0 },
                completion: { _ in
                    DispatchQueue.main.asyncAfter(
                        deadline: .now() + 0.5,
                        execute: {
                            hideNotificationAnimated()
                        })
                }
            )
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
