//
//  ProvidesCollectionViewCell.swift
//  HostList
//
//  Created by Vladislav Lisianskii on 01.01.2024.
//

import UIKit

public protocol ProvidesCollectionViewCell<ItemIdentifierType> {
    associatedtype ItemIdentifierType: Hashable, Sendable

    func makeCollectionViewCell(
        _ collectionView: UICollectionView,
        _ indexPath: IndexPath,
        _ itemIdentifier: ItemIdentifierType
    ) -> UICollectionViewCell?
}
