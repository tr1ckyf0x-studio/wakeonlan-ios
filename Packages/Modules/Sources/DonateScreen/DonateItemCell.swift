//
//  DonateItemCell.swift
//  
//
//  Created by Vladislav Lisianskii on 15.04.2023.
//

import SnapKit
import UIKit
import WOLResources
import WOLUIComponents

final class DonateItemCell: UITableViewCell {

    // MARK: - Appearance

    private let appearance = Appearance(); struct Appearance {
        let backgroundColor = Asset.Colors.primary.color
        let labelColor = Asset.Colors.secondaryVariant.color

        let labelsHorizontalInset = 16
        let labelsVerticalInset = 16
        let containerHorizontalInset = 16
        let containerVerticalInset = 8

        let primaryFont = UIFont.systemFont(ofSize: 14, weight: .bold)
    }

    // MARK: - Properties

    private var viewModel: ProductViewModel?

    private lazy var baseView: SoftUIView = {
        let view = SoftUIView()
        view.type = .normal
        view.addTarget(self, action: #selector(didTap(_:)), for: .touchUpInside)
        return view
    }()

    private lazy var titleLabel: UILabel = { label in
        label.font = appearance.primaryFont
        label.textColor = appearance.labelColor
        return label
    }(UILabel())

    private lazy var priceLabel: UILabel = { label in
        label.font = appearance.primaryFont
        label.textColor = appearance.labelColor
        label.textAlignment = .right
        return label
    }(UILabel())

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        makeConstraints()
        makeAppearance()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(model: ProductViewModel) {
        viewModel = model
        titleLabel.text = model.title
        priceLabel.text = model.price
    }
}

// MARK: - Private
extension DonateItemCell {

    private func addSubviews() {
        contentView.addSubview(baseView)
        baseView.addSubview(titleLabel)
        baseView.addSubview(priceLabel)
    }

    private func makeConstraints() {
        baseView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(appearance.containerHorizontalInset)
            make.verticalEdges.equalToSuperview().inset(appearance.containerVerticalInset)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(appearance.labelsHorizontalInset)
            make.trailing.equalTo(priceLabel.snp.leading).inset(appearance.labelsHorizontalInset)
            make.verticalEdges.equalToSuperview().inset(appearance.labelsVerticalInset)
        }

        priceLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(appearance.labelsHorizontalInset)
            make.verticalEdges.equalToSuperview().inset(appearance.labelsVerticalInset)
        }
    }

    private func makeAppearance() {
        contentView.backgroundColor = appearance.backgroundColor
    }

    @objc private func didTap(_ softUIView: SoftUIView) {
        viewModel?.onClick()
    }
}
