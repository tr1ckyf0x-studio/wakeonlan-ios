//
//  HostListCollectionManager.swift
//  HostList
//
//  Created by Vladislav Lisianskii on 01.01.2024.
//

import SharedProtocolsAndModels

typealias HostListCollectionDataSource = UICollectionViewDiffableDataSource<HostListSection, HostListItem>

protocol ManagesHostListCollection:
    HostListCollectionDataSource,
    UICollectionViewDelegate { }

final class HostListCollectionManager: HostListCollectionDataSource, ManagesHostListCollection {

    typealias CellProvider = ProvidesCollectionViewCell<HostListItem>

    init(collectionView: UICollectionView, cellProvider: any CellProvider) {
        super.init(collectionView: collectionView, cellProvider: cellProvider.makeCollectionViewCell)
    }
}
