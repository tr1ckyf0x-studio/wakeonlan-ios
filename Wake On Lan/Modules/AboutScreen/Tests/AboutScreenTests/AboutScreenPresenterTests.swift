import XCTest

@testable import AboutScreen
@testable import WOLResources
import SharedRouterMock

final class AboutScreenPresenterTests: XCTest {
    var sut: AboutScreenPresenter!
    var interactorMock: AboutScreenInteractorInputMock!
    var viewController: AboutScreenViewInputMock!
    // var routerMock: RouterMock!

    override func setUp() {
        super.setUp()
        interactorMock = AboutScreenInteractorInputMock()
        viewController = AboutScreenViewInputMock()
        // routerMock = RouterMock()
        sut = AboutScreenPresenter()
        sut.interactor = interactorMock
        sut.interactor = interactorMock
        // sut.router = routerMock
    }

    func testViewDidLoad() {
        // when
        sut.viewDidLoad(viewController)
        // then
        XCTAssertEqual(interactorMock.fetchBundleInfoCallsCount, 1, "Interactor must be called once")
    }
}
