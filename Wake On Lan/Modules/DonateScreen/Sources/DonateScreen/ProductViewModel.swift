//
//  ProductViewModel.swift
//  
//
//  Created by Vladislav Lisianskii on 15.04.2023.
//

import Foundation

struct ProductViewModel {
    /// Product localized title
    let title: String

    /// Product localized price
    let price: String

    /// On-click action
    let onClick: () -> Void
}

// MARK: - Equatable

extension ProductViewModel: Equatable {
    static func == (lhs: ProductViewModel, rhs: ProductViewModel) -> Bool {
        [
            lhs.title == rhs.title,
            lhs.price == rhs.price
        ].allSatisfy { $0 }
    }
}

// MARK: - Hashable

extension ProductViewModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(price)
    }
}
