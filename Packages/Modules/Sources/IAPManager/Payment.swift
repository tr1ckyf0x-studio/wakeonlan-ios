//
//  Payment.swift
//  
//
//  Created by Vladislav Lisianskii on 16.04.2023.
//

import StoreKit

final class Payment: NSObject {

    enum Error: Swift.Error {
        case transactionFailed(error: Swift.Error?)
    }

    private let paymentQueue: SKPaymentQueue
    private var payment: SKPayment?
    private var continuation: CheckedContinuation<Void, Swift.Error>?

    init(
        paymentQueue: SKPaymentQueue
    ) {
        self.paymentQueue = paymentQueue
        super.init()
        paymentQueue.add(self)
    }

    func enqueue(product: SKProduct) async throws {
        let payment = SKPayment(product: product)
        self.payment = payment
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Swift.Error>) in
            self.continuation = continuation
            paymentQueue.add(payment)
        }
    }
}

// MARK: - SKPaymentTransactionObserver
extension Payment: SKPaymentTransactionObserver {
    func paymentQueue(
        _ queue: SKPaymentQueue,
        updatedTransactions transactions: [SKPaymentTransaction]
    ) {
        let transaction = transactions.first { (transaction: SKPaymentTransaction) -> Bool in
            transaction.payment == payment
        }

        guard let transaction else { return }

        switch transaction.transactionState {
        case .purchased, .restored:
            complete(transaction: transaction)

        case .failed:
            fail(transaction: transaction)

        case .deferred, .purchasing:
            break

        @unknown default:
            break
        }
    }

    func paymentQueue(
        _ queue: SKPaymentQueue,
        shouldAddStorePayment payment: SKPayment,
        for product: SKProduct
    ) -> Bool {
        true
    }
}

// MARK: - Private
extension Payment {
    private func complete(transaction: SKPaymentTransaction) {
        paymentQueue.finishTransaction(transaction)
        continuation?.resume(returning: Void())
    }

    private func fail(transaction: SKPaymentTransaction) {
        paymentQueue.finishTransaction(transaction)
        continuation?.resume(throwing: Error.transactionFailed(error: transaction.error))
    }
}
