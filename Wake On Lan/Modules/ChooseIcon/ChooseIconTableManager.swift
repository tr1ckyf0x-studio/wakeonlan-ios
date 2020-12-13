//
//  ChooseIconTableManager.swift
//  Wake on LAN
//
//  Created by Dmitry Stavitsky on 28.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit
import WOLUIComponents

protocol ChooseIconTableManagerDelegate: class {
    func tableManager(_ manager: ChooseIconTableManager, didTapIcon icon: IconModel)
}

class ChooseIconTableManager: NSObject {
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

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        sections[section].content.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionModel = sections[indexPath.section].content[indexPath.row]
        var cell: UICollectionViewCell?

        switch sectionModel {
        case .icon(let model):
            let iconCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "\(ChooseIconCell.self)", for: indexPath) as? ChooseIconCell
            let didTapIconBlock: ChooseIconCell.TapIconBlock = { [unowned self] _ in
                self.delegate?.tableManager(self, didTapIcon: model)
            }
            iconCell?.configure(with: model, didTapBlock: didTapIconBlock)
            cell = iconCell

        default:
            break
        }

        guard let unwrappedCell = cell else {
            fatalError("\(self): Unknown cell identifier")
        }

        return unwrappedCell
    }

}
