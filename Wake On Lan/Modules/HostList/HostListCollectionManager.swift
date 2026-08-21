//
//  HostListCollectionManager.swift
//  HostList
//
//  Created by Vladislav Lisianskii on 01.01.2024.
//

import UIKit
import WOLSharedProtocolsAndModels

typealias HostListCollectionDataSource = UICollectionViewDiffableDataSource<HostListSection, HostListItem>

protocol ManagesHostListCollection:
    HostListCollectionDataSource,
    UICollectionViewDelegate { }

@MainActor
protocol HostListCollectionManagerDelegate: AnyObject {
    func hostListCollectionManager(
        _ hostListCollectionManager: ManagesHostListCollection,
        moveRowAt sourceIndexPath: IndexPath,
        to destinationIndexPath: IndexPath
    )
}

final class HostListCollectionManager: HostListCollectionDataSource, ManagesHostListCollection {
    // MARK: - Properties

    typealias CellProvider = ProvidesCollectionViewCell<HostListItem>

    weak var delegate: HostListCollectionManagerDelegate?

    private lazy var longPressGesture = UILongPressGestureRecognizer(
        target: self,
        action: #selector(handleLongGesture(gesture:))
    )

    private weak var collectionView: UICollectionView?

    // MARK: - Init

    init(collectionView: UICollectionView, cellProvider: any CellProvider) {
        super.init(collectionView: collectionView, cellProvider: cellProvider.makeCollectionViewCell)
        self.collectionView = collectionView
        collectionView.addGestureRecognizer(longPressGesture)
        // The diffable data source only applies an interactive move to its snapshot while reordering
        // is allowed. Reordering itself is driven manually by `longPressGesture`.
        reorderingHandlers.canReorderItem = { _ in true }
    }

    // MARK: - DataSource

    override func collectionView(
        _ collectionView: UICollectionView,
        moveItemAt sourceIndexPath: IndexPath,
        to destinationIndexPath: IndexPath
    ) {
        // NOTE: `super` moves the item inside the snapshot so that it matches what the collection
        // view has already drawn. Skipping it leaves the snapshot in the pre-drag order while the
        // collection view is in the post-drag one, and the next applied snapshot replays the move on
        // top of the visual result. The two index spaces then never converge, so a tap resolves to
        // the wrong host — the packet is sent to another machine and delete removes another host.
        super.collectionView(collectionView, moveItemAt: sourceIndexPath, to: destinationIndexPath)
        delegate?.hostListCollectionManager(self, moveRowAt: sourceIndexPath, to: destinationIndexPath)
    }
}

// MARK: - Private

extension HostListCollectionManager {
    @objc private func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        guard let collectionView else { return }
        switch gesture.state {
        case .began:
            guard let selectedIndexPath = collectionView.indexPathForItem(
                at: gesture.location(in: collectionView)
            ) else {
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
