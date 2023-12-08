//
//  DonateScreenView.swift
//  
//
//  Created by Vladislav Lisianskii on 14.04.2023.
//

import UIKit
import WOLResources
import WOLUIComponents

protocol DonateScreenViewDelegate: AnyObject {
    func donateScreenViewDidPressBackButton(_ view: DonateScreenView)
}

final class DonateScreenView: UIView {

    // MARK: - Appearance

    private let appearance = Appearance(); struct Appearance {
        let backgroundColor = Asset.Colors.primary.color

        let backBarButtonSize: CGFloat = 32.0
        let backBarButtonImageViewInset: CGFloat = 6.0
        let backBarButtonTintColor = Asset.Colors.secondary.color
        let backBarButtonImage = UIImage(
            sfSymbol: ButtonIcon.chevronBackward,
            withConfiguration: .init(weight: .semibold)
        )
    }

    // MARK: - Properties

    weak var delegate: DonateScreenViewDelegate?

    lazy var backBarButton: UIBarButtonItem = {
        let imageView = UIImageView(image: appearance.backBarButtonImage)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = appearance.backBarButtonTintColor
        let button = SoftUIView(circleShape: true)
        button.configure(with: SoftUIViewModel(contentView: imageView))
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(appearance.backBarButtonImageViewInset)
        }
        button.snp.makeConstraints { make in
            make.size.equalTo(appearance.backBarButtonSize)
        }

        button.addTarget(self, action: #selector(didPressBackButton(_:)), for: .touchUpInside)

        return .init(customView: button)
    }()

    lazy var tableView: UITableView = {
        let tableView = UITableView(
            frame: .zero,
            style: .grouped
        )
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.backgroundColor = appearance.backgroundColor

        return tableView
    }()

    lazy var paymentsUnavailableView: EmptyView = {
        let paymentsUnavailableView = EmptyView()
        let viewModel = StateableViewModel(
            title: L10n.DonateScreen.Screen.paymentsUnavailable,
            image: Asset.Assets.owl.image,
            backgroundColor: Asset.Colors.primary.color
        )
        paymentsUnavailableView.configure(with: viewModel)

        return paymentsUnavailableView
    }()

    lazy var spinnerView: SpinnerView = { view in
        view.stopAnimating()
        view.isHidden = true
        return view
    }(SpinnerView())

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        makeConstraints()
        makeAppearance()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var stateViews: [UIView] {
        [
            tableView,
            paymentsUnavailableView,
            spinnerView
        ]
    }
}

// MARK: - Private
extension DonateScreenView {
    private func addSubviews() {
        addSubview(tableView)
        addSubview(paymentsUnavailableView)
        addSubview(spinnerView)
    }

    private func makeConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }

        paymentsUnavailableView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }

        spinnerView.snp.makeConstraints { make in
            make.center.equalTo(safeAreaLayoutGuide)
        }
    }

    private func makeAppearance() {
        backgroundColor = appearance.backgroundColor
    }

    @objc private func didPressBackButton(_ button: SoftUIView) {
        delegate?.donateScreenViewDidPressBackButton(self)
    }
}
