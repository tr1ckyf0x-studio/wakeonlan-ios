//
//  DonateScreenContract.swift
//  
//
//  Created by Vladislav Lisianskii on 15.04.2023.
//

import IAPManager

protocol DonateScreenViewInput: AnyObject {
    func setSections(_ sections: [DonateScreenTableSectionModel])
    func showState(_ state: DonateScreenState)
}

protocol DonateScreenViewOutput {
    func viewDidLoad(_ view: DonateScreenViewInput)
    func viewDidPressBackButton(_ view: DonateScreenViewInput)
}

protocol DonateScreenInteractorInput {
    var canMakePayments: Bool { get }

    func fetchPurchases()
    func makePurchase(product: Product)
}

protocol DonateScreenInteractorOutput: AnyObject {
    func interactor(_ interactor: DonateScreenInteractorInput, didLoad products: [Product])
    func interactorDidStartPurchasing(_ interactor: DonateScreenInteractorInput)
    func interactorDidFinishPurchasing(_ interactor: DonateScreenInteractorInput)
}
