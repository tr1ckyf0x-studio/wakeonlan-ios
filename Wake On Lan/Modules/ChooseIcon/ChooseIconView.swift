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
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        // Space between columns
        layout.minimumInteritemSpacing = 10
        // Space between rows
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 16, bottom: 0, right: 16)
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
        collectionView.backgroundColor = .white
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(safeAreaLayoutGuide)
        }
    }

}
