//
//  UITableView+Autoregistration.swift
//
//
//  Created by Vladislav Lisianskii on 29.08.2023.
//

import UIKit

public extension UITableView {
    /// Returns cell with autoregistration
    /// - Parameters:
    ///   - cellType: Cell type
    ///   - reuseID: Reuse identifier
    /// - Returns: Cell
    func dequeueReusableCellWithAutoregistration<Cell: UITableViewCell>(
        _ cellType: Cell.Type,
        reuseID: String? = nil
    ) -> Cell {
        registerCell(cellType, reuseID: reuseID)
        let cell = dequeueReusableCell(cellType, reuseID: reuseID)
        assert(
            cell != nil,
            "UITableView can not dequeue cell with type \(cellType) for reuseID \(reuseID ?? defaultReuseID(of: cellType))" // swiftlint:disable:this line_length
        )
        guard let cell else { return Cell() }
        return cell
    }

    /// Returns cell without autoregistration
    /// - Parameters:
    ///   - cellType: Cell type
    ///   - reuseID: Reuse identifier
    /// - Returns: Cell
    func dequeueReusableCell<Cell: UITableViewCell>(_ cellType: Cell.Type, reuseID: String? = nil) -> Cell? {
        let normalizedReuseID = reuseID ?? defaultReuseID(of: cellType)
        return dequeueReusableCell(withIdentifier: normalizedReuseID) as? Cell
    }

    /// Registers cell
    /// - Parameters:
    ///   - cellType: Cell type
    ///   - reuseID: Reuse identifier
    func registerCell<Cell: UITableViewCell>(_ cellType: Cell.Type, reuseID: String? = nil) {
        let normalizedReuseID = reuseID ?? defaultReuseID(of: cellType)
        register(cellType, forCellReuseIdentifier: normalizedReuseID)
    }
}

// MARK: - Private

private extension UITableView {
    func defaultReuseID(of cellType: UITableViewCell.Type) -> String {
        String(describing: cellType.self)
    }
}
