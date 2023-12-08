//
//  DonateScreenInteractor.swift
//  
//
//  Created by Vladislav Lisianskii on 14.04.2023.
//

import CocoaLumberjack
import IAPManager

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
                await MainActor.run {
                    presenter?.interactor(self, didLoad: products)
                }
            } catch {
                DDLogError("\(error)")
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

            await MainActor.run {
                presenter?.interactorDidFinishPurchasing(self)
            }
        }
    }
}
