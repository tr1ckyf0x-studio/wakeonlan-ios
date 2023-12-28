//
//  ChooseIconTableManager.swift
//  Wake on LAN
//
//  Created by Dmitry Stavitsky on 28.05.2020.
//  Copyright © 2020 Vladislav Lisianskii. All rights reserved.
//

import SharedProtocolsAndModels
import UIKit

protocol ChooseIconTableManagerDelegate: AnyObject {
    func tableManager(_ manager: ChooseIconTableManager, didTapIcon icon: IconModel)
}

final class ChooseIconTableManager: NSObject {
    var sections: [ChooseIconSection]
    weak var delegate: ChooseIconTableManagerDelegate?

    init(with sections: [ChooseIconSection]) {
        self.sections = sections
        super.init()
    }
}

// MARK: - UICollectionViewDelegate

extension ChooseIconTableManager: UICollectionViewDelegate {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
}

// MARK: - UICollectionViewDataSource

extension ChooseIconTableManager: UICollectionViewDataSource {

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        sections[section].content.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let sectionModel = sections[indexPath.section].content[indexPath.row]
        var cell: UICollectionViewCell?

        if case let .icon(model) = sectionModel {
            let iconCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "\(ChooseIconCell.self)",
                for: indexPath
            ) as? ChooseIconCell
            let didTapIconBlock: ChooseIconCell.TapIconBlock = { [weak self] _ in
                guard let self else { return }
                self.delegate?.tableManager(self, didTapIcon: model)
            }

            iconCell.map {
                $0.configure(with: model, didTapBlock: didTapIconBlock)
                cell = $0
            }
        }

        guard let cell else {
            fatalError("\(self): Unknown cell identifier")
        }

        return cell
    }
}
