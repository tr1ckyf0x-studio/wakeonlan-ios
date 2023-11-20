//
//  IAPManager.swift
//  
//
//  Created by Vladislav Lisianskii on 16.04.2023.
//

import SharedProtocolsAndModels
import StoreKit

public protocol ManagesIAP {

    /// Indicates if manager can make payments
    var canMakePayments: Bool { get }

    /// Returns available products
    func fetchProducts(withIDs productIDs: Set<String>) async throws -> [Product]

    /// Adds purchase to queue
    func makePurchase(product: Product) async throws
}

public final class IAPManager: NSObject {

    private let paymentManager: ManagesPayments

    init(
        paymentManager: ManagesPayments
    ) {
        self.paymentManager = paymentManager
        super.init()
    }

    override public convenience init() {
        self.init(
            paymentManager: PaymentManager(paymentQueue: .default())
        )
    }
}

// MARK: - ManagesIAP
extension IAPManager: ManagesIAP {
    public var canMakePayments: Bool {
        SKPaymentQueue.canMakePayments()
    }

    public func fetchProducts(withIDs productIDs: Set<String>) async throws -> [Product] {
        try await ProductsRequest().fetch(productIDs: productIDs)
            .sorted(by: { (lhs: SKProduct, rhs: SKProduct) -> Bool in
                lhs.price.compare(rhs.price) == .orderedAscending
            })
            .compactMap { (product: SKProduct) -> Product? in
                guard let price = formattedPrice(for: product) else { return nil }
                return Product(
                    title: product.localizedTitle,
                    price: price,
                    identifier: product.productIdentifier
                )
            }
    }

    public func makePurchase(product: Product) async throws {
        let skProduct = try await ProductsRequest().fetch(productIDs: Set([product.identifier])).first
        guard let skProduct else { return }

        try await paymentManager.enqueue(product: skProduct)
    }
}

// MARK: - Private
extension IAPManager {
    private func formattedPrice(for product: SKProduct) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = product.priceLocale
        return formatter.string(from: product.price)
    }
}

// MARK: - ProvidesWeakSharedInstanceTrait
extension IAPManager: ProvidesWeakSharedInstanceTrait {
    public static weak var weakSharedInstance: IAPManager?
}
