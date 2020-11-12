//
//  ChooseIconPresenterSpec.swift
//  WakeOnLanTests
//
//  Created by Владислав Лисянский on 01.11.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import Wake_on_LAN

class ChooseIconPresenterSpec: QuickSpec {

    override func spec() {
        var presenter: ChooseIconPresenter!
        var viewController: ChooseIconViewControllerMock!
        var moduleDelegate: ChooseIconModuleDelegateMock!
        var tableManager: ChooseIconTableManager!

        beforeEach {
            presenter = ChooseIconPresenter()
            viewController = ChooseIconViewControllerMock()
            moduleDelegate = ChooseIconModuleDelegateMock()
            tableManager = presenter.tableManager

            presenter.view = viewController
            presenter.moduleDelegate = moduleDelegate
        }

        describe("viewDidLoad(_:)") {
            it("should call view.makePresentingViewControllerDimmed()") {
                presenter.viewDidLoad(viewController)
                expect(viewController.didCallMakePresentingViewControllerDimmed).to(beTrue())
            }
        }

        describe("viewWillDisappear(_:)") {
            it("should call view.makePresentingViewControllerTransparent()") {
                presenter.viewWillDisappear(viewController)
                expect(viewController.didCallMakePresentingViewControllerTransparent).to(beTrue())
            }
        }

        describe("viewWillLayoutSubviews(_:)") {
            it("should call view.reloadCollectionViewLayout()") {
                presenter.viewWillLayoutSubviews(viewController)
                expect(viewController.didCallReloadCollectionViewLayout).to(beTrue())
            }

            it("should call view.updateIconViewHeight()") {
                presenter.viewWillLayoutSubviews(viewController)
                expect(viewController.didCallUpdateIconViewHeight).to(beTrue())
            }
        }

        describe("tableManager(_:, didTapIcon:)") {
            it("should call moduleDelegate?.chooseIconModuleDidSelectIcon(_:)") {
                let iconModel = IconModel(pictureName: "testPicture")
                presenter.tableManager(tableManager, didTapIcon: iconModel)
                expect(moduleDelegate.setIconModel).to(equal(iconModel))
                expect(moduleDelegate.didCallChooseIconModuleDidSelectIcon).to(beTrue())
            }

            it("should call view.dismiss(animated:)") {
                presenter.tableManager(tableManager, didTapIcon: .init())
                expect(viewController.didCallDismiss).to(beTrue())
            }
        }
    }
}
