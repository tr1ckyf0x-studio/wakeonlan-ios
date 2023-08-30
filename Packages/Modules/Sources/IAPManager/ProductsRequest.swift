//
//  ProductsRequest.swift
//  
//
//  Created by Vladislav Lisianskii on 16.04.2023.
//

import StoreKit

final class ProductsRequest: NSObject {

    enum ProductsRequestError: Error {
        case noProductsFound
        case productRequestFailed
    }

    private var continuation: CheckedContinuation<[SKProduct], Error>?

    func fetch(productIDs: Set<String>) async throws -> [SKProduct] {
        try await withCheckedThrowingContinuation { [weak self] continuation in
            self?.continuation = continuation

            let request = SKProductsRequest(productIdentifiers: productIDs)
            request.delegate = self
            request.start()
        }
    }
}

// MARK: - SKProductsRequestDelegate

extension ProductsRequest: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let products = response.products

        if products.isEmpty {
            continuation?.resume(throwing: ProductsRequestError.noProductsFound)
        } else {
            continuation?.resume(returning: products)
        }
    }

    func request(_ request: SKRequest, didFailWithError error: Error) {
        continuation?.resume(throwing: ProductsRequestError.productRequestFailed)
    }
}
