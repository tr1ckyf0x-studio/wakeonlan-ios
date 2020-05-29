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

extension ChooseIconTableManager: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        referenceSizeForHeaderInSection section: Int) -> CGSize {
//        let indexPath = IndexPath(row: 0, section: 0)
//        guard let headerView = self.collectionView(
//            collectionView,
//            viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader,
//            at: indexPath) as? ChooseIconHeaderView else { return .zero }
//        headerView.layoutIfNeeded()
//        let targetSize = CGSize(width: collectionView.frame.width,
//                                height: UIView.layoutFittingExpandedSize.height)
//
//        return headerView.fittingSizeFor(targetSize: targetSize)
//    }

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

//    func collectionView(_ collectionView: UICollectionView,
//                        viewForSupplementaryElementOfKind kind: String,
//                        at indexPath: IndexPath) -> UICollectionReusableView {
//        guard kind == UICollectionView.elementKindSectionHeader,
//            let headerView =
//            collectionView.dequeueReusableSupplementaryView(
//                ofKind: kind,
//                withReuseIdentifier: "\(ChooseIconHeaderView.self)",
//                for: indexPath) as? ChooseIconHeaderView else {
//                    return UICollectionReusableView()
//        }
//
//        return headerView
//    }

}
