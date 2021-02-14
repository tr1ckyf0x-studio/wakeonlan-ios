//
//  ChooseIconView.swift
//  Wake on LAN
//
//  Created by Dmitry Stavitsky on 28.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit
import WOLResources

class ChooseIconView: UIView {

    lazy var collectionView: UICollectionView = {
        let layout = ChooseIconCollectionLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(
            ChooseIconCell.self,
            forCellWithReuseIdentifier: "\(ChooseIconCell.self)"
        )
        collectionView.alwaysBounceVertical = true

        return collectionView
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = R.color.soft()
        setupCollectionView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCollectionView() {
        addSubview(collectionView)
        collectionView.backgroundColor = .clear
        collectionView.snp.makeConstraints {
            $0.leading.trailing.equalTo(safeAreaLayoutGuide)
            $0.top.equalTo(safeAreaLayoutGuide).inset(8)
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
    }

}
