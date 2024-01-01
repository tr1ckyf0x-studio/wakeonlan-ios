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

    private lazy var longPressGesture = UILongPressGestureRecognizer(
        target: self,
        action: #selector(handleLongGesture(gesture:))
    )

    private weak var collectionView: UICollectionView?

    init(collectionView: UICollectionView, cellProvider: any CellProvider) {
        super.init(collectionView: collectionView, cellProvider: cellProvider.makeCollectionViewCell)
        self.collectionView = collectionView
        collectionView.addGestureRecognizer(longPressGesture)
    }

    override func collectionView(
        _ collectionView: UICollectionView,
        moveItemAt sourceIndexPath: IndexPath,
        to destinationIndexPath: IndexPath
    ) {
        delegate?.hostListCollectionManager(self, moveRowAt: sourceIndexPath, to: destinationIndexPath)
    }
}

// MARK: - Private

extension HostListCollectionManager {
    @objc private func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        guard let collectionView else { return }
        switch gesture.state {

        case .began:
            guard let selectedIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else {
                break
            }
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)

        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view))

        case .ended:
            collectionView.endInteractiveMovement()

        default:
            collectionView.cancelInteractiveMovement()
        }
    }
}
