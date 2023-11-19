//
//  PaymentManager.swift
//
//
//  Created by Vladislav Lisianskii on 16.04.2023.
//

import StoreKit

protocol ManagesPayments {
    func enqueue(product: SKProduct) async throws
}

final class PaymentManager: NSObject {

    private let paymentQueue: SKPaymentQueue
    private var payments: [SKPayment: CheckedContinuation<Void, Swift.Error>] = [:]

    init(
        paymentQueue: SKPaymentQueue
    ) {
        self.paymentQueue = paymentQueue
        super.init()
        paymentQueue.add(self)
    }
}

// MARK: - ManagesPayments

extension PaymentManager: ManagesPayments {
    func enqueue(product: SKProduct) async throws {
        let payment = SKPayment(product: product)
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Swift.Error>) in
            self.payments[payment] = continuation
            paymentQueue.add(payment)
        }
    }
}

// MARK: - SKPaymentTransactionObserver

extension PaymentManager: SKPaymentTransactionObserver {
    func paymentQueue(
        _ queue: SKPaymentQueue,
        updatedTransactions transactions: [SKPaymentTransaction]
    ) {
        transactions
            .filter { (transaction: SKPaymentTransaction) -> Bool in
                payments[transaction.payment] != nil
            }
            .forEach { (transaction: SKPaymentTransaction) in
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

extension PaymentManager {
    private func complete(transaction: SKPaymentTransaction) {
        paymentQueue.finishTransaction(transaction)
        let continuation = payments.removeValue(forKey: transaction.payment)
        continuation?.resume(returning: Void())
    }

    private func fail(transaction: SKPaymentTransaction) {
        paymentQueue.finishTransaction(transaction)
        let continuation = payments.removeValue(forKey: transaction.payment)
        continuation?.resume(throwing: Error.transactionFailed(error: transaction.error))
    }
}

// MARK: - Error

extension PaymentManager {
    private enum Error: Swift.Error {
        case transactionFailed(error: Swift.Error?)
    }
}
