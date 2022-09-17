import XCTest

@testable import AboutScreen
@testable import WOLResources

final class AboutScreenPresenterTests: XCTestCase {
    var sut: AboutScreenPresenter!
    var interactorMock: AboutScreenInteractorInputMock!
    var viewMock: AboutScreenViewInputMock!

    override func setUp() {
        super.setUp()
        interactorMock = AboutScreenInteractorInputMock()
        viewMock = AboutScreenViewInputMock()
        sut = AboutScreenPresenter()
        sut.interactor = interactorMock
        sut.view = viewMock
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
        let viewModel = TestData.viewModel
        // when
        sut.interactor(interactorMock, didFetchBundleInfo: bundleInfo)
        // then
        XCTAssertEqual(viewMock.configureWithCallsCount, 1, "ViewController must be called once")
        XCTAssertEqual(viewMock.configureWithReceivedViewModel?.buttonListViewModel.count,
                       viewModel.buttonListViewModel.count,
                       "the number of button items must equal 3"
        )
        XCTAssertEqual(viewMock.configureWithReceivedViewModel?.headerViewModel, viewModel.headerViewModel)
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
        static let viewModel = AboutScreenViewViewModel(
            headerViewModel: .init(name: bundleInfo.name, version: bundleInfo.version),
            buttonListViewModel: [
                AboutScreenMenuButtonViewViewModel(
                    title: "",
                    symbol: ButtonIcon.share,
                    action: nil
                ),
                AboutScreenMenuButtonViewViewModel(
                    title: "",
                    symbol: ButtonIcon.tag,
                    action: nil
                ),
                AboutScreenMenuButtonViewViewModel(
                    title: "",
                    symbol: ButtonIcon.star,
                    action: nil
                )
            ]
        )
    }
}
