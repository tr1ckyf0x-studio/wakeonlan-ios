//
//  ChooseIconHeaderView.swift
//  Wake on LAN
//
//  Created by Dmitry Stavitsky on 29.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit

class ChooseIconHeaderView: UICollectionReusableView {

    private let headerLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 28, weight: .semibold)
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.text = "Choose icon" // TODO: R.swift
        label.sizeToFit()

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(headerLabel)
        headerLabel.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(24)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func fittingSizeFor(targetSize size: CGSize) -> CGSize {
        return headerLabel.systemLayoutSizeFitting(
            size,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel)
    }

}
