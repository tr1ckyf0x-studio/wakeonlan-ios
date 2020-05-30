//
//  ChooseIconTableManager.swift
//  Wake on LAN
//
//  Created by Dmitry Stavitsky on 28.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit

class ChooseIconTableManager: NSObject {
    var sections: [ChooseIconSection]

    init(with sections: [ChooseIconSection]) {
        self.sections = sections
        super.init()
    }

}

// MARK: - UICollectionViewDelegate
extension ChooseIconTableManager: UICollectionViewDelegate {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

}

// MARK: - UICollectionViewDataSource
extension ChooseIconTableManager: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return sections[section].content.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionModel = sections[indexPath.section].content[indexPath.row]
        var cell: UICollectionViewCell?

        switch sectionModel {
        case .icon(let model):
            let iconCell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "\(ChooseIconCell.self)", for: indexPath) as? ChooseIconCell
            iconCell?.configure(with: model)
            cell = iconCell
        }

        guard let unwrappedCell = cell else {
            fatalError("\(self): Unknown cell identifier")
        }

        return unwrappedCell
    }

}
