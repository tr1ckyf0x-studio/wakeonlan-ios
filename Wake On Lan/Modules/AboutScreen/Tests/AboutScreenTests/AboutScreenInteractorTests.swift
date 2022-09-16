import XCTest

@testable import AboutScreen
@testable import WOLResources
import WOLResourcesMock

final class AboutScreenInteractorTests: XCTestCase {

    var sut: AboutScreenInteractor!
    var bundleInfoProviderMock: ProvidesBundleInfoMock!
    var presenterMock: AboutScreenInteractorOutputMock!

    override func setUp() {
        super.setUp()
        bundleInfoProviderMock = ProvidesBundleInfoMock()
        presenterMock = AboutScreenInteractorOutputMock()
        sut = AboutScreenInteractor(bundleInfoProvider: bundleInfoProviderMock)
        sut.presenter = presenterMock
    }

    func testFetchBundleInfo() {
        // given
        let bundleInfo = TestData.bundleInfo
        bundleInfoProviderMock.fetchBundleInfoReturnValue = bundleInfo
        // when
        sut.fetchBundleInfo()
        // then
        XCTAssertEqual(
            presenterMock.interactorDidFetchBundleInfoCallsCount,
            1,
            "presenter must be called once"
        )
        XCTAssertEqual(
            presenterMock.interactorDidFetchBundleInfoReceivedArguments?.bundleInfo,
            bundleInfo,
            "interactor must call presenter with bundle info received from bundleInfoProvider"
        )
    }
}

private extension AboutScreenInteractorTests {
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
