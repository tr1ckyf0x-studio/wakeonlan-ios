import XCTest

@testable import AboutScreen
import WOLResourcesMock

final class AboutScreenInteractorTests: XCTestCase {

    var sut: AboutScreenInteractor!
    var bundleInfoProviderMock: ProvidesBundleInfoMock!

    override func setUp() {
        super.setUp()
        bundleInfoProviderMock = ProvidesBundleInfoMock()
        sut = AboutScreenInteractor(bundleInfoProvider: bundleInfoProviderMock)
    }
}
