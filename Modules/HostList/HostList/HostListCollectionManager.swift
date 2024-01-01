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
    UICollectionViewDelegate,
    UICollectionViewDragDelegate,
    UICollectionViewDropDelegate { }

protocol HostListCollectionManagerDelegate: AnyObject {
    func hostListCollectionManager(
        _ hostListCollectionManager: ManagesHostListCollection,
        moveRowAt sourceIndexPath: IndexPath,
        to destinationIndexPath: IndexPath
    )
}

final class HostListCollectionManager: HostListCollectionDataSource, ManagesHostListCollection {

    typealias CellProvider = ProvidesCollectionViewCell<HostListItem>

    weak var delegate: HostListCollectionManagerDelegate?

    init(collectionView: UICollectionView, cellProvider: any CellProvider) {
        super.init(collectionView: collectionView, cellProvider: cellProvider.makeCollectionViewCell)
    }

    override func collectionView(
        _ collectionView: UICollectionView,
        moveItemAt sourceIndexPath: IndexPath,
        to destinationIndexPath: IndexPath
    ) {
        delegate?.hostListCollectionManager(self, moveRowAt: sourceIndexPath, to: destinationIndexPath)
    }
}

// MARK: - UICollectionViewDragDelegate

extension HostListCollectionManager {
    func collectionView(
        _ collectionView: UICollectionView,
        itemsForBeginning session: UIDragSession,
        at indexPath: IndexPath
    ) -> [UIDragItem] {
        [UIDragItem(itemProvider: NSItemProvider())]
    }
}

// MARK: - UICollectionViewDropDelegate

extension HostListCollectionManager {
    func collectionView(
        _ collectionView: UICollectionView,
        dropSessionDidUpdate session: UIDropSession,
        withDestinationIndexPath destinationIndexPath: IndexPath?
    ) -> UICollectionViewDropProposal {
        guard session.localDragSession != nil else {
            return UICollectionViewDropProposal(operation: .cancel, intent: .unspecified)
        }

        return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }

    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) { }
}
