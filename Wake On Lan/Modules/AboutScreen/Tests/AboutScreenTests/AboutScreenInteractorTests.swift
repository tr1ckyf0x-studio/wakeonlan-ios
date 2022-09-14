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
        let bundleInfo = BundleInfo(
            displayName: "",
            identifier: "",
            name: "",
            version: "",
            build: "",
            appFonts: nil
        )

        bundleInfoProviderMock.fetchBundleInfoReturnValue = bundleInfo
        sut.fetchBundleInfo()
        XCTAssertEqual(presenterMock.interactorDidFetchBundleInfoCallsCount, 1, "presenter must be called once")
        XCTAssertEqual(presenterMock.interactorDidFetchBundleInfoReceivedArguments?.bundleInfo.name, bundleInfo.name, "interactor must call presenter with bundle info received from bundleInfoProvider")
    }
}
