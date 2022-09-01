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
import SharedProtocolsAndModels
import WOLResources
@testable import AddHost

class AddHostPresenterSpec: QuickSpec {

    // swiftlint:disable function_body_length
    override func spec() {
        var sut: AddHostPresenter<AddHostRouterProtocolMock>!
        var interactorMock: AddHostInteractorInputMock!
        var viewControllerMock: AddHostViewInputMock!
        var routerMock: AddHostRouterProtocolMock!
        var tableManager: AddHostTableManager!

        beforeEach {
            sut = AddHostPresenter()
            interactorMock = AddHostInteractorInputMock()
            viewControllerMock = AddHostViewInputMock()
            routerMock = AddHostRouterProtocolMock()
            tableManager = sut.tableManager

            sut.view = viewControllerMock
            sut.interactor = interactorMock
            sut.router = routerMock
        }

        describe("viewDidLoad") {
            it("should reload table") {
                sut.viewDidLoad(viewControllerMock)
                expect(viewControllerMock.reloadTableCalled).to(beTrue())
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
                    sut.viewDidPressSaveButton(viewControllerMock)
                    expect(interactorMock.saveFormCalled).to(beFalse())
                    expect(interactorMock.updateFormCalled).to(beFalse())
                }
            }
        }

        describe("viewDidPressBackButton(_:)") {
            it("should call router?.popCurrentController(animated:)") {
                sut.viewDidPressBackButton(viewControllerMock)
                expect(routerMock.popCurrentControllerAnimatedCalled).to(beTrue())
            }
        }

        describe("interactor(_:, didSaveForm:)") {
            it("should call router?.popCurrentController(animated:)") {
                sut.interactor(interactorMock, didSaveForm: sut.addHostForm)
                expect(routerMock.popCurrentControllerAnimatedCalled).to(beTrue())
            }
        }

        describe("interactor(_:, didUpdateForm:)") {
            it("should call router?.popCurrentController(animated:)") {
                sut.interactor(interactorMock, didUpdateForm: sut.addHostForm)
                expect(routerMock.popCurrentControllerAnimatedCalled).to(beTrue())
            }
        }

        describe("tableManagerDidTapDeviceIconCell(_:, _:)") {
            it("should call router?.routeToChooseIcon()") {
                sut.tableManagerDidTapDeviceIconCell(tableManager, .init())
                expect(routerMock.routeToChooseIconCalled).to(beTrue())
            }
        }

        describe("chooseIconModuleDidSelectIcon(_:)") {
            it("should set iconModel to addHostForm") {
                let iconModel = IconModel()
                sut.chooseIconModuleDidSelectIcon(iconModel)
                expect(sut.addHostForm.iconModel).to(equal(iconModel))
            }

            it("should call view?.reloadTable()") {
                sut.chooseIconModuleDidSelectIcon(.init())
                expect(viewControllerMock.reloadTableWithCalled).to(beTrue())
            }
        }

    }
}
