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
import SharedProtocolsAndModels
@testable import AddHost

class ChooseIconPresenterSpec: QuickSpec {

    override func spec() {
        var sut: ChooseIconPresenter!
        var viewControllerMock: ChooseIconViewInputMock!
        var moduleOutputMock: ChooseIconModuleOutputMock!
        var routerMock: ChooseIconRouterProtocolMock!
        var tableManager: ChooseIconTableManager!

        beforeEach {
            sut = ChooseIconPresenter()
            viewControllerMock = ChooseIconViewInputMock()
            moduleOutputMock = ChooseIconModuleOutputMock()
            routerMock = ChooseIconRouterProtocolMock()
            tableManager = sut.tableManager

            sut.view = viewControllerMock
            sut.moduleDelegate = moduleOutputMock
            sut.router = routerMock
        }

        describe("viewWillLayoutSubviews(_:)") {
            it("should call view.reloadCollectionViewLayout()") {
                sut.viewWillLayoutSubviews(viewControllerMock)
                expect(viewControllerMock.reloadCollectionViewLayoutCalled).to(beTrue())
            }

            it("should call view.updateIconViewHeight()") {
                sut.viewWillLayoutSubviews(viewControllerMock)
                expect(viewControllerMock.updateIconViewHeightCalled).to(beTrue())
            }
        }

        describe("tableManager(_:, didTapIcon:)") {
            it("should call moduleDelegate?.chooseIconModuleDidSelectIcon(_:)") {
                let iconModel = IconModel()
                sut.tableManager(tableManager, didTapIcon: iconModel)
                expect(moduleOutputMock.chooseIconModuleDidSelectIconCalled).to(beTrue())
                expect(moduleOutputMock.chooseIconModuleDidSelectIconReceivedIconModel).to(equal(iconModel))
            }

            it("should call view.dismiss(animated:)") {
                sut.tableManager(tableManager, didTapIcon: .init())
                expect(routerMock.dismissAnimatedCalled).to(beTrue())
            }
        }
    }
}
