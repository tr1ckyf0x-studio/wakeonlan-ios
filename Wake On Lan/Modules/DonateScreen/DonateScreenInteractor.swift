//
//  DonateScreenInteractor.swift
//  
//
//  Created by Vladislav Lisianskii on 14.04.2023.
//

import CocoaLumberjackSwift

@MainActor
final class DonateScreenInteractor {
    weak var presenter: DonateScreenInteractorOutput?
    private let iAPManager: ManagesIAP

    init(
        iAPManager: ManagesIAP
    ) {
        self.iAPManager = iAPManager
    }
}

// MARK: - DonateScreenInteractorInput

extension DonateScreenInteractor: DonateScreenInteractorInput {
    var canMakePayments: Bool {
        iAPManager.canMakePayments
    }

    func fetchPurchases() {
        Task {
            do {
                let products = try await iAPManager.fetchProducts(
                    withIDs: Set(ProductIdentifier.allCases.map(\.rawValue))
                )
                presenter?.interactor(self, didLoad: products)
            } catch {
                DDLogError("\(error)")
                // NOTE: Without this the screen stayed on `.loading` forever — the spinner was the
                // only feedback a failed product fetch ever produced.
                presenter?.interactorDidFailToLoad(self, error: error)
            }
        }
    }

    func makePurchase(product: Product) {
        presenter?.interactorDidStartPurchasing(self)
        Task {
            do {
                try await iAPManager.makePurchase(product: product)
            } catch {
                print(error)
            }

            presenter?.interactorDidFinishPurchasing(self)
        }
    }
}
