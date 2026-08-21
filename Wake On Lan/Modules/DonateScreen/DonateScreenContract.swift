//
//  DonateScreenContract.swift
//  
//
//  Created by Vladislav Lisianskii on 15.04.2023.
//

@MainActor
protocol DonateScreenViewInput: AnyObject {
    func setSections(_ sections: [DonateScreenTableSectionModel])
    func showState(_ state: DonateScreenState)
}

@MainActor
protocol DonateScreenViewOutput {
    func viewDidLoad(_ view: DonateScreenViewInput)
    func viewDidPressBackButton(_ view: DonateScreenViewInput)
}

@MainActor
protocol DonateScreenInteractorInput {
    var canMakePayments: Bool { get }

    func fetchPurchases()
    func makePurchase(product: Product)
}

@MainActor
protocol DonateScreenInteractorOutput: AnyObject {
    func interactor(_ interactor: DonateScreenInteractorInput, didLoad products: [Product])
    func interactorDidFailToLoad(_ interactor: DonateScreenInteractorInput, error: Error)
    func interactorDidStartPurchasing(_ interactor: DonateScreenInteractorInput)
    func interactorDidFinishPurchasing(_ interactor: DonateScreenInteractorInput)
}
