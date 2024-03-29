//
//  HostListCollectionViewCell.swift
//  HostList
//
//  Created by Vladislav Lisianskii on 01.01.2024.
//

import CocoaLumberjack
import CoreDataService
import Reachability
import WOLResources
import WOLUIComponents

// MARK: - HostListCollectionViewCell

final class HostListCollectionViewCell: UICollectionViewCell {

    // MARK: - Typealiases

    typealias Default = HostListNotificationView<NotificationViewType.Default>
    typealias Failure = HostListNotificationView<NotificationViewType.Failure>

    // MARK: - Properties

    private var viewModel: HostListCellViewModel?

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
        let image = UIImage(sfSymbol: ButtonIcon.trash, withConfiguration: symbolConfiguration)
        let imageView = UIImageView(image: image)
        imageView.tintColor = WOLResources.Asset.Colors.secondary.color
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
        let image = UIImage(sfSymbol: ButtonIcon.ellipsis, withConfiguration: imageConfiguration)
        let imageView = UIImageView(image: image)
        imageView.tintColor = WOLResources.Asset.Colors.secondary.color
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

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public

    func configure(with viewModel: HostListCellViewModel, delegate: HostListCollectionViewCellDelegate?) {
        let sfSymbol = SFSymbolFactory.build(from: viewModel.iconName)
        let image = sfSymbol.flatMap { UIImage(sfSymbol: $0) }
        hostTitle.text = viewModel.title
        deviceImageView.image = image
        macAddressTitle.text = viewModel.macAddress
        self.viewModel = viewModel
        self.delegate = delegate
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

    @objc func displayNotification() {
        guard let reachability = try? Reachability() else {
            DDLogWarn("It is impossible to determine the connection type")
            return
        }

        let isReachable = reachability.connection != .unavailable
        let notificationView = isReachable ? Default() : Failure()

        baseView.addSubview(notificationView)
        notificationView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(28)
        }

        let animationDuration = 0.2
        let hideNotificationAnimated = {
            UIView.animate(
                withDuration: animationDuration,
                animations: { notificationView.alpha = 0.0 },
                completion: { _ in
                    notificationView.removeFromSuperview()
                }
            )
        }

        let displayNotificationAnimated = {
            UIView.animate(
                withDuration: animationDuration,
                animations: { notificationView.alpha = 1.0 },
                completion: { _ in
                    DispatchQueue.main.asyncAfter(
                        deadline: .now() + 0.9,
                        execute: {
                            hideNotificationAnimated()
                        })
                }
            )
        }

        delegate?.hostListCellDidTap(self)

        UINotificationFeedbackGenerator().notificationOccurred(.success)
        displayNotificationAnimated()
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
