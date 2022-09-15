import XCTest

@testable import AboutScreen
import SharedRouterMock

final class AboutScreenPresenterTests: XCTest {
    var sut: AboutScreenPresenter!
    var interactorMock: AboutScreenInteractorInputMock!
    var routerMock: RouterMock!

    override func setUp() {
        super.setUp()
        interactorMock = AboutScreenInteractorInputMock()
        routerMock = RouterMock()
        sut = AboutScreenPresenter()
        sut.interactor = interactorMock
        sut.interactor = interactorMock
        sut.router = routerMock
    }
}
