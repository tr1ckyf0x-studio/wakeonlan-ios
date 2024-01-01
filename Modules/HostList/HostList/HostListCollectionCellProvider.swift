//
//  HostListCollectionCellProvider.swift
//  HostList
//
//  Created by Vladislav Lisianskii on 01.01.2024.
//

import SharedExtensions
import SharedProtocolsAndModels

struct HostListCollectionCellProvider: ProvidesCollectionViewCell {

    private weak var hostCellDelegate: HostListCollectionViewCellDelegate?

    init(hostCellDelegate: HostListCollectionViewCellDelegate? = nil) {
        self.hostCellDelegate = hostCellDelegate
    }

    func makeCollectionViewCell(
        _ collectionView: UICollectionView,
        _ indexPath: IndexPath,
        _ item: HostListSectionItem
    ) -> UICollectionViewCell? {
        switch item {
        case let .host(viewModel):
            let cell = collectionView.dequeueReusableCellWithAutoregistration(
                HostListCollectionViewCell.self,
                indexPath: indexPath
            )
            cell.configure(with: viewModel, delegate: hostCellDelegate)
            return cell
        }
    }
}
