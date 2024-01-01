//
//  UICollectionView+Autoregistration.swift
//  SharedExtensions
//
//  Created by Vladislav Lisianskii on 01.01.2024.
//

import UIKit

public extension UICollectionView {
    /// Returns cell with autoregistration
    /// - Parameters:
    ///   - cellType: Cell type
    ///   - indexPath: IndexPath
    ///   - reuseID: Reuse identifier
    /// - Returns: Cell
    func dequeueReusableCellWithAutoregistration<Cell: UICollectionViewCell>(
        _ cellType: Cell.Type,
        indexPath: IndexPath,
        reuseID: String? = nil
    ) -> Cell {
        registerCell(cellType, reuseID: reuseID)
        let cell = dequeueReusableCell(cellType, indexPath: indexPath, reuseID: reuseID)
        assert(
            cell != nil,
            "UICollectionView can not dequeue cell with type \(cellType) for reuseID \(reuseID ?? defaultReuseID(of: cellType))" // swiftlint:disable:this line_length
        )
        guard let cell else { return Cell() }
        return cell
    }

    /// Returns cell without autoregistration
    /// - Parameters:
    ///   - cellType: Cell type
    ///   - indexPath: IndexPath
    ///   - reuseID: Reuse identifier
    /// - Returns: Cell
    func dequeueReusableCell<Cell: UICollectionViewCell>(
        _ cellType: Cell.Type,
        indexPath: IndexPath,
        reuseID: String? = nil
    ) -> Cell? {
        let normalizedReuseID = reuseID ?? defaultReuseID(of: cellType)
        return dequeueReusableCell(withReuseIdentifier: normalizedReuseID, for: indexPath) as? Cell
    }

    /// Registers cell
    /// - Parameters:
    ///   - cellType: Cell type
    ///   - reuseID: Reuse identifier
    func registerCell<Cell: UICollectionViewCell>(_ cellType: Cell.Type, reuseID: String? = nil) {
        let normalizedReuseID = reuseID ?? defaultReuseID(of: cellType)
        register(cellType, forCellWithReuseIdentifier: normalizedReuseID)
    }
}

// MARK: - Private

private extension UICollectionView {
    func defaultReuseID(of cellType: UICollectionViewCell.Type) -> String {
        String(describing: cellType.self)
    }
}
