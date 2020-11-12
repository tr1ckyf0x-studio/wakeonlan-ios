//
//  AddHostPresenterSpec.swift
//  WakeOnLanTests
//
//  Created by Владислав Лисянский on 01.11.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import Wake_on_LAN

class AddHostPresenterSpec: QuickSpec {

    // swiftlint:disable function_body_length
    override func spec() {
        var presenter: AddHostPresenter!
        var interactorMock: AddHostInteractorMock!
        var viewController: AddHostViewControllerMock!
        var router: AddHostRouterMock!
        var tableManager: AddHostTableManager!

        beforeEach {
            presenter = AddHostPresenter()
            interactorMock = AddHostInteractorMock()
            viewController = AddHostViewControllerMock()
            router = AddHostRouterMock()
            tableManager = presenter.tableManager

            presenter.view = viewController
            presenter.interactor = interactorMock
            presenter.router = router
        }

        describe("viewDidLoad") {
            it("should reload table") {
                presenter.viewDidLoad(viewController)
                expect(viewController.didCallReloadTable).to(beTrue())
            }
        }

        describe("viewDidPressSaveButton") {
            context("form is valid") {
                beforeEach {
                    // TODO: set form state
                }

                context("form contains host") {
                    // TODO: set host to form
                    it("should call interactor?.updateForm(_:)") {
//                        expect(interactorMock.didCallUpdateForm).to(beTrue())
                    }
                }

                context("form does not contain host") {
                    it("should call interactor?.saveForm(_:)") {
//                        expect(interactorMock.didCallSaveForm).to(beTrue())
                    }
                }

            }

            context("form is not valid") {
                it("should not save or update form") {
                    presenter.viewDidPressSaveButton(viewController)
                    expect(interactorMock.didCallSaveForm).to(beFalse())
                    expect(interactorMock.didCallUpdateForm).to(beFalse())
                }
            }
        }

        describe("viewDidPressBackButton(_:)") {
            it("should call router?.popCurrentController(animated:)") {
                presenter.viewDidPressBackButton(viewController)
                expect(router.didCallPopCurrentController).to(beTrue())
            }
        }

        describe("interactor(_:, didSaveForm:)") {
            it("should call router?.popCurrentController(animated:)") {
                presenter.interactor(interactorMock, didSaveForm: presenter.addHostForm)
                expect(router.didCallPopCurrentController).to(beTrue())
            }
        }

        describe("interactor(_:, didUpdateForm:)") {
            it("should call router?.popCurrentController(animated:)") {
                presenter.interactor(interactorMock, didUpdateForm: presenter.addHostForm)
                expect(router.didCallPopCurrentController).to(beTrue())
            }
        }

        describe("tableManagerDidTapDeviceIconCell(_:, _:)") {
            it("should call router?.routeToChooseIcon()") {
                presenter.tableManagerDidTapDeviceIconCell(tableManager, .init())
                expect(router.didCallRouteToChooseIcon).to(beTrue())
            }
        }

        describe("chooseIconModuleDidSelectIcon(_:)") {
            it("should set iconModel to addHostForm") {
                let iconModel = IconModel(pictureName: "testPic")
                presenter.chooseIconModuleDidSelectIcon(iconModel)
                expect(presenter.addHostForm.iconModel).to(equal(iconModel))
            }

            it("should call view?.reloadTable()") {
                presenter.chooseIconModuleDidSelectIcon(.init())
                expect(viewController.didCallReloadTable).to(beTrue())
            }
        }

    }
}
