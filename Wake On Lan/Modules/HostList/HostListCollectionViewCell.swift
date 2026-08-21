//
//  HostListCollectionViewCell.swift
//  HostList
//
//  Created by Vladislav Lisianskii on 01.01.2024.
//

import UIKit

// MARK: - HostListCollectionViewCell

final class HostListCollectionViewCell: UICollectionViewCell {
    // MARK: - Typealiases

    typealias Default = HostListNotificationView<NotificationViewType.Default>
    typealias Failure = HostListNotificationView<NotificationViewType.Failure>

    // MARK: - Properties

    private var viewModel: HostListCellViewModel?

    private var notificationView: UIView?
    private var hideNotificationWorkItem: DispatchWorkItem?

    private weak var delegate: HostListCollectionViewCellDelegate?

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.alwaysBounceHorizontal = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.clipsToBounds = false

        return scrollView
    }()

    private let scrollViewContentView = UIView()

    private lazy var deleteButton: SoftUIView = {
        let button = SoftUIView()
        let symbolConfiguration = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 36, weight: .regular))
        let image = UIImage(systemSymbol: .trash, withConfiguration: symbolConfiguration)
        let imageView = UIImageView(image: image)
        imageView.tintColor = Asset.Colors.secondary.color
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
        view.addTarget(self, action: #selector(didTapBaseView), for: .touchUpInside)

        return view
    }()

    private let deviceImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = Asset.Colors.secondary.color
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()

    private let hostTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = Asset.Colors.secondaryVariant.color
        label.numberOfLines = 1
        label.textAlignment = .left

        return label
    }()

    private let macAddressTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.textColor = Asset.Colors.secondaryVariant.color
        label.numberOfLines = 1
        label.textAlignment = .left

        return label
    }()

    private lazy var infoButton: SoftUIView = {
        let button = SoftUIView(circleShape: true)
        let imageConfiguration = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 24, weight: .semibold))
        let image = UIImage(systemSymbol: .ellipsis, withConfiguration: imageConfiguration)
        let imageView = UIImageView(image: image)
        imageView.tintColor = Asset.Colors.secondary.color
        button.configure(with: SoftUIViewModel(contentView: imageView))
        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        button.addTarget(self, action: #selector(didTapInfoButton), for: .touchUpInside)

        return button
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Asset.Colors.primary.color
        setupScrollView()
        setupBaseView()
        setupDeleteView()
        setupImageView()
        setupInfoButton()
        setupHostTitle()
        setupMacAddressTitle()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public

    // NOTE: A recycled cell must not inherit the previous host's state. The swipe affordance lives
    // entirely in the scroll view's content offset, so without this reset a card can be drawn
    // already swiped open with the delete button under the user's thumb, and a stale "Packet sent"
    // banner can appear over a host that was never tapped.
    override func prepareForReuse() {
        super.prepareForReuse()
        hideNotificationWorkItem?.cancel()
        hideNotificationWorkItem = nil
        notificationView?.removeFromSuperview()
        notificationView = nil
        scrollView.setContentOffset(.zero, animated: false)
    }

    func configure(with viewModel: HostListCellViewModel, delegate: HostListCollectionViewCellDelegate?) {
        let hostIcon = HostIcon(systemName: viewModel.iconName)
        let image = hostIcon.map { UIImage(systemSymbol: $0.symbol) }
        hostTitle.text = viewModel.title
        deviceImageView.image = image
        macAddressTitle.text = viewModel.macAddress
        self.viewModel = viewModel
        self.delegate = delegate
    }

    /// Shows the outcome of a wake attempt on this card.
    ///
    /// - Note: Driven by the presenter once the send has actually finished. Deciding it here, at tap
    ///   time, meant the card always claimed success — including when no packet left the device.
    func showNotification(_ notification: HostListNotification) {
        hideNotificationWorkItem?.cancel()
        self.notificationView?.removeFromSuperview()

        let notificationView: UIView
        let feedbackType: UINotificationFeedbackGenerator.FeedbackType

        switch notification {
        case .packetSent:
            notificationView = Default()
            feedbackType = .success

        case .failure:
            notificationView = Failure()
            feedbackType = .error
        }

        self.notificationView = notificationView
        baseView.addSubview(notificationView)
        notificationView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(28)
        }

        let animationDuration = 0.2
        let hideNotificationAnimated = DispatchWorkItem { [weak self] in
            UIView.animate(
                withDuration: animationDuration,
                animations: { notificationView.alpha = 0.0 },
                completion: { _ in
                    notificationView.removeFromSuperview()
                    if self?.notificationView === notificationView {
                        self?.notificationView = nil
                    }
                }
            )
        }
        hideNotificationWorkItem = hideNotificationAnimated

        let displayNotificationAnimated = {
            UIView.animate(
                withDuration: animationDuration,
                animations: { notificationView.alpha = 1.0 },
                completion: { _ in
                    DispatchQueue.main.asyncAfter(
                        deadline: .now() + 0.9,
                        execute: hideNotificationAnimated
                    )
                }
            )
        }

        UINotificationFeedbackGenerator().notificationOccurred(feedbackType)
        displayNotificationAnimated()
    }
}

// MARK: - Private

private extension HostListCollectionViewCell {
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
        baseView.snp.makeConstraints { make in
            make.leading.verticalEdges.equalToSuperview()
            make.size.equalTo(scrollView)
        }
    }

    func setupDeleteView() {
        scrollViewContentView.addSubview(deleteButton)
        deleteButton.snp.makeConstraints { make in
            make.verticalEdges.equalTo(baseView)
            make.leading.equalTo(baseView.snp.trailing).offset(20)
            make.trailing.equalToSuperview()
            make.width.equalTo(deleteButton.snp.height)
        }
    }

    func setupImageView() {
        baseView.addSubview(deviceImageView)
        deviceImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(80)
        }
    }

    func setupHostTitle() {
        baseView.addSubview(hostTitle)
        hostTitle.snp.makeConstraints { make in
            make.leading.equalTo(deviceImageView.snp.trailing).offset(16)
            make.top.equalToSuperview().offset(32)
            make.trailing.equalTo(infoButton.snp.leading).offset(-8)
        }
    }

    func setupMacAddressTitle() {
        baseView.addSubview(macAddressTitle)
        macAddressTitle.snp.makeConstraints { make in
            make.leading.equalTo(hostTitle.snp.leading)
            make.top.equalTo(hostTitle.snp.bottom).offset(8)
        }
    }

    func setupInfoButton() {
        baseView.addSubview(infoButton)
        infoButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
            make.width.height.equalTo(Constants.infoButtonSize)
        }
    }

    // MARK: - Action

    @objc func didTapInfoButton() {
        delegate?.hostListCellDidTapInfo(self)
    }

    @objc func didTapDeleteButton() {
        delegate?.hostListCellDidTapDelete(self)
    }

    @objc func didTapBaseView() {
        delegate?.hostListCellDidTap(self)
    }
}

// MARK: - UIScrollViewDelegate

extension HostListCollectionViewCell: UIScrollViewDelegate {
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

extension HostListCollectionViewCell {
    enum Constants {
        static let cellHeight: CGFloat = 112
        static let horizontalInset: CGFloat = 16
        static let verticalInset: CGFloat = 16

        fileprivate static let infoButtonSize = 40
    }
}
