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

    // MARK: - Properties

    private let paymentQueue: SKPaymentQueue
    private let lock = NSLock()
    private var payments: [SKPayment: CheckedContinuation<Void, Swift.Error>] = [:]

    // MARK: - Init

    init(
        paymentQueue: SKPaymentQueue
    ) {
        self.paymentQueue = paymentQueue
        super.init()
        paymentQueue.add(self)
    }

    deinit {
        paymentQueue.remove(self)
    }
}

// MARK: - ManagesPayments

extension PaymentManager: ManagesPayments {
    func enqueue(product: SKProduct) async throws {
        let payment = SKPayment(product: product)
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Swift.Error>) in
            store(continuation, for: payment)
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
        // NOTE: Transactions without a matching in-flight payment are handled too. They arrive for
        // promoted App Store purchases and for purchases interrupted by termination; leaving them
        // unfinished keeps them pending in the queue forever, so the user is charged while the app
        // acknowledges nothing and StoreKit re-delivers them on every launch.
        transactions.forEach { (transaction: SKPaymentTransaction) in
            switch transaction.transactionState {
            case .purchased, .restored:
                complete(transaction: transaction)

            case .failed:
                fail(transaction: transaction)

            // NOTE: "Ask to Buy" is terminal for this session — approval arrives in a later launch,
            // so the caller must not stay suspended. The transaction is deliberately left unfinished
            // because StoreKit re-delivers it once a parent responds.
            case .deferred:
                resumeContinuation(for: transaction.payment, with: .failure(Error.transactionDeferred))

            case .purchasing:
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
        resumeContinuation(for: transaction.payment, with: .success(()))
    }

    private func fail(transaction: SKPaymentTransaction) {
        paymentQueue.finishTransaction(transaction)
        resumeContinuation(
            for: transaction.payment,
            with: .failure(Error.transactionFailed(error: transaction.error))
        )
    }

    private func store(
        _ continuation: CheckedContinuation<Void, Swift.Error>,
        for payment: SKPayment
    ) {
        lock.lock()
        defer { lock.unlock() }
        payments[payment] = continuation
    }

    /// `payments` is written from the caller's task and read from StoreKit's observer callback, so
    /// every access is serialised by `lock`.
    private func resumeContinuation(
        for payment: SKPayment,
        with result: Result<Void, Swift.Error>
    ) {
        lock.lock()
        let continuation = payments.removeValue(forKey: payment)
        lock.unlock()
        continuation?.resume(with: result)
    }
}

// MARK: - Error

extension PaymentManager {
    private enum Error: Swift.Error {
        case transactionFailed(error: Swift.Error?)
        case transactionDeferred
    }
}
