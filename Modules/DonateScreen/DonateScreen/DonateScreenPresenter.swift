//
//  DonateScreenPresenter.swift
//  
//
//  Created by Vladislav Lisianskii on 14.04.2023.
//

import Foundation
import IAPManager
import SharedRouter

final class DonateScreenPresenter: Navigates {
    var interactor: DonateScreenInteractorInput?
    var router: DonateScreenRoutes?
    weak var view: DonateScreenViewInput?
}

// MARK: - DonateScreenViewOutput
extension DonateScreenPresenter: DonateScreenViewOutput {
    func viewDidLoad(_ view: DonateScreenViewInput) {
        guard interactor?.canMakePayments == true else {
            view.showState(.paymentsUnavailable)
            return
        }
        view.showState(.loading)
        interactor?.fetchPurchases()
    }

    func viewDidPressBackButton(_ view: DonateScreenViewInput) {
        navigate(to: router?.backOrDismiss(animated: true))
    }
}

// MARK: - DonateScreenInteractorOutput
extension DonateScreenPresenter: DonateScreenInteractorOutput {
    func interactor(_ interactor: DonateScreenInteractorInput, didLoad products: [Product]) {
        let productItems = products.map { (product: Product) -> DonateScreenTableSectionItem in
            let viewModel = ProductViewModel(
                title: product.title,
                price: product.price,
                onClick: { [weak self] in
                    self?.interactor?.makePurchase(product: product)
                }
            )
            return DonateScreenTableSectionItem.purchase(viewModel)
        }
        let section = DonateScreenTableSectionModel.donateSection(
            content: productItems,
            footer: L10n.DonateScreen.Screen.footer
        )

        view?.setSections([section])
        view?.showState(.loaded)
    }

    func interactorDidStartPurchasing(_ interactor: DonateScreenInteractorInput) {
        view?.showState(.loading)
    }

    func interactorDidFinishPurchasing(_ interactor: DonateScreenInteractorInput) {
        view?.showState(.loaded)
    }
}
