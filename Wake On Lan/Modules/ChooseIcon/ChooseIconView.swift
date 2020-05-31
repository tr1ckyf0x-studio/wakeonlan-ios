//
//  ChooseIconView.swift
//  Wake on LAN
//
//  Created by Dmitry Stavitsky on 28.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit

class ChooseIconView: UIView {

    lazy var collectionView: UICollectionView = {
        let layout = ChooseIconCollectionLayout()
        let collectionView =
            UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ChooseIconCell.self,
                                forCellWithReuseIdentifier: "\(ChooseIconCell.self)")
        collectionView.alwaysBounceVertical = true

        return collectionView
    }()


    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupCollectionView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCollectionView() {
        addSubview(collectionView)
        collectionView.backgroundColor = .clear
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(safeAreaLayoutGuide)
        }
    }

}
