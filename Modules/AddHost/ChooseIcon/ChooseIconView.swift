//
//  ChooseIconView.swift
//  Wake on LAN
//
//  Created by Dmitry Stavitsky on 28.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit
import WOLResources

final class ChooseIconView: UIView {

    private let appearance = Appearance(); struct Appearance {
        let collectionViewTopOffset: CGFloat = 8.0
        let collectionViewBottomOffset: CGFloat = 8.0
    }

    lazy var collectionView: UICollectionView = {
        let layout = ChooseIconCollectionLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ChooseIconCell.self, forCellWithReuseIdentifier: "\(ChooseIconCell.self)")
        collectionView.alwaysBounceVertical = true
        collectionView.delaysContentTouches = false

        return collectionView
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Asset.Colors.primary.color
        setupCollectionView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCollectionView() {
        addSubview(collectionView)
        collectionView.backgroundColor = .clear
        collectionView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalToSuperview().offset(appearance.collectionViewTopOffset)
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(appearance.collectionViewBottomOffset)
        }
    }
}
