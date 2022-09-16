import XCTest

@testable import AboutScreen
@testable import WOLResources
import SharedRouterMock

// TODO: either fix router mock or remove all references to router from this test

final class AboutScreenPresenterTests: XCTest {
    var sut: AboutScreenPresenter!
    var interactorMock: AboutScreenInteractorInputMock!
    var viewMock: AboutScreenViewInputMock!
    // var routerMock: RouterMock!

    override func setUp() {
        super.setUp()
        interactorMock = AboutScreenInteractorInputMock()
        viewMock = AboutScreenViewInputMock()
        // routerMock = RouterMock()
        sut = AboutScreenPresenter()
        sut.interactor = interactorMock
        // sut.router = routerMock
    }

    func testViewDidLoad() {
        // when
        sut.viewDidLoad(viewMock)
        // then
        XCTAssertEqual(interactorMock.fetchBundleInfoCallsCount, 1, "Interactor must be called once")
    }

    func testIntercatorDidFetchBundleInfo() {
        // given
        let bundleInfo = TestData.bundleInfo
        // when
        sut.interactor(interactorMock, didFetchBundleInfo: bundleInfo)
        // then
        XCTAssertEqual(viewMock.configureWithCallsCount, 1, "ViewController must be called once")
        // Can not test viewConfigureWith receivedViewModel, as the view model is created with presenter's privateMethod
    }
}

private extension AboutScreenPresenterTests {
    enum TestData {
        static let bundleInfo = BundleInfo(
            displayName: "",
            identifier: "",
            name: "",
            version: "",
            build: "",
            appFonts: nil
        )
    }
}
