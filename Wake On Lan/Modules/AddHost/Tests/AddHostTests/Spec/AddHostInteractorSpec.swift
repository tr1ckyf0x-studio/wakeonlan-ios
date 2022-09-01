//
//  AddHostInteractorSpec.swift
//  WakeOnLanTests
//
//  Created by Владислав Лисянский on 01.11.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import AddHost

// TODO: Is not testable until Core Data stack is mocked
class AddHostInteractorSpec: QuickSpec {

    override func spec() {
//        var sut: AddHostInteractor!
//        var presenter: AddHostInteractorOutputMock!

//        beforeEach {
//            presenter = AddHostInteractorOutputMock()
//            sut = AddHostInteractor()
//
//            sut.presenter = presenter
//        }

        describe("saveForm(_:)") {
            it("should call presenter?.interactor(_:, didSaveForm:)") {
//                TODO: Is not testable until Core Data stack is mocked
//                let form = AddHostForm()
//                interactor.saveForm(form)
//                expect(presenter.interactorDidUpdateForm).to(beTrue())
            }
        }

        describe("updateForm(_:)") {
            context("form contains host") {
                it("should call presenter?.interactor(_:, didUpdateForm:)") {
//                    TODO: Is not testable until Core Data stack is mocked
//                    let form = AddHostForm()
//                    interactor.updateForm(form)
//                    expect(presenter.interactorDidUpdateForm).to(beTrue())
                }
            }

            context("form does not contain host") {
                it("should not call presenter?.interactor(_:, didUpdateForm:)") {
//                    TODO: Is not testable until Core Data stack is mocked
//                    let form = AddHostForm()
//                    interactor.updateForm(form)
//                    expect(presenter.interactorDidUpdateForm).to(beFalse())
                }
            }
        }
    }
}
