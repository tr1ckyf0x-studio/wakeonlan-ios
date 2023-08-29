//
//  Product.swift
//  
//
//  Created by Vladislav Lisianskii on 16.04.2023.
//

public struct Product {
    /// Localized title
    public let title: String

    /// Localized price
    public let price: String

    /// Product identifier
    public let identifier: String

    internal init(
        title: String,
        price: String,
        identifier: String
    ) {
        self.title = title
        self.price = price
        self.identifier = identifier
    }
}
