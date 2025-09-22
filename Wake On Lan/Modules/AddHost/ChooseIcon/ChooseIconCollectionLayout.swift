//
//  ChooseIconCollectionLayout.swift
//  Wake on LAN
//
//  Created by Dmitry Stavitsky on 29.05.2020.
//  Copyright © 2020 Vladislav Lisianskii. All rights reserved.
//

import UIKit

final class ChooseIconCollectionLayout: UICollectionViewFlowLayout {

    // MARK: - Constants

    private enum Constants {
        static let numberOfColumns = 4
        static let spaceBetweenColumns: CGFloat = 16
        static let spaceBetweenRows: CGFloat = 16
        static let insets = UIEdgeInsets(top: 5, left: 16, bottom: 0, right: 16)
    }

    // MARK: - Properties

    var display: ChooseIconCollectionDisplay = .grid(columns: Constants.numberOfColumns) {
        didSet {
            guard display == oldValue else {
                invalidateLayout()
                return
            }
        }
    }

    var containerHeight: CGFloat {
        guard let itemsCount = collectionView?.numberOfItems(inSection: .zero) else { return .zero }
        let numberOfRows = (CGFloat(itemsCount) / CGFloat(Constants.numberOfColumns)).rounded(.up)
        let itemHeight = itemSize.height
        var totalHeight = minimumInteritemSpacing * (numberOfRows - 1)
        totalHeight += numberOfRows * itemHeight + minimumInteritemSpacing

        return totalHeight
    }

    var containerWidth: CGFloat = .zero {
         didSet {
            guard containerWidth == oldValue else {
                invalidateLayout()
                return
            }
         }
     }

    // MARK: - Init

    override init() {
        super.init()
        sectionInset = Constants.insets
        minimumLineSpacing = Constants.spaceBetweenRows
        minimumInteritemSpacing = Constants.spaceBetweenColumns
    }

    required init?(coder: NSCoder) {
        fatalError("\(ChooseIconCollectionLayout.self) : init(coder:) has not been implemented")
    }

    // MARK: - Private

    private func configureLayoutIfNeeded() {
        switch display {
        case .grid(let column):
            // NOTE: Prevents warning
            // `negative or zero item sizes are not supported in the flow layout`
            guard containerWidth > 0 else { return }
            scrollDirection = .vertical
            let spacing = CGFloat(column - 1) * minimumLineSpacing
            let widthWithInsets = containerWidth - sectionInset.left - sectionInset.right
            let optimisedWidth = ((widthWithInsets - spacing) / CGFloat(column)).rounded(.down)
            itemSize = CGSize(width: optimisedWidth, height: optimisedWidth) // keep as square
        }
    }

    override func invalidateLayout() {
        super.invalidateLayout()
        configureLayoutIfNeeded()
    }
}

// MARK: - ChooseIconCollectionDisplay

enum ChooseIconCollectionDisplay {
    case grid(columns: Int)
}

extension ChooseIconCollectionDisplay: Equatable {

    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case let (grid(lcolumns), .grid(rcolumns)):
            return lcolumns == rcolumns
        }
    }
}
