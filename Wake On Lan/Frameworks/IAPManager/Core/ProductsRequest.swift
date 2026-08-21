//
//  ProductsRequest.swift
//
//
//  Created by Vladislav Lisianskii on 16.04.2023.
//

import StoreKit

// NOTE: deliberately not `@MainActor`. `SKProductsRequestDelegate` is a pre-concurrency StoreKit
// protocol and its callbacks arrive on StoreKit's own queue. Isolating this type to the main actor
// makes Swift insert a dynamic check that trips (`_dispatch_assert_queue_fail`) the moment StoreKit
// answers — which is every failed fetch on a real device. `lock` is what makes the type safe instead.
final class ProductsRequest: NSObject {
    // MARK: - Properties

    private let lock = NSLock()
    private var continuation: CheckedContinuation<[SKProduct], Error>?

    // MARK: - Internal

    func fetch(productIDs: Set<String>) async throws -> [SKProduct] {
        try await withCheckedThrowingContinuation { continuation in
            lock.lock()
            self.continuation = continuation
            lock.unlock()

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
        guard !products.isEmpty else {
            resume(with: .failure(ProductsRequestError.noProductsFound))
            return
        }
        resume(with: .success(products))
    }

    func request(_ request: SKRequest, didFailWithError error: Error) {
        resume(with: .failure(ProductsRequestError.productRequestFailed(underlying: error)))
    }
}

// MARK: - Private

extension ProductsRequest {
    /// Resumes the continuation exactly once, from whichever StoreKit callback arrives first.
    private func resume(with result: Result<[SKProduct], Error>) {
        lock.lock()
        let continuation = self.continuation
        self.continuation = nil
        lock.unlock()
        continuation?.resume(with: result)
    }
}

// MARK: - Error

extension ProductsRequest {
    enum ProductsRequestError: LocalizedError {
        case noProductsFound
        case productRequestFailed(underlying: Error)

        var errorDescription: String? {
            switch self {
            case .noProductsFound:
                return "No products were returned by the App Store"

            case .productRequestFailed:
                return "The product request failed"
            }
        }

        var failureReason: String? {
            switch self {
            case .noProductsFound:
                return nil

            case let .productRequestFailed(underlying):
                return underlying.localizedDescription
            }
        }
    }
}
