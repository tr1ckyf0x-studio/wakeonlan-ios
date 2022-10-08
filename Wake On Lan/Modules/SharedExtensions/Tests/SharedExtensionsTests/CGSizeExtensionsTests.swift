import XCTest
import CoreGraphics

@testable import SharedExtensions

final class CGSizeExtensionsTests: XCTestCase {
    func testInverse() {
        XCTAssertEqual(TestData.sizePositiveWidth.inversed, TestData.expectedSizePositiveWidth, "it must inverse sign")
        XCTAssertEqual(TestData.sizeNegativeWidth.inversed, TestData.expectedSizeNegativeWidth, "it must inverse sign")
    }
}

private extension CGSizeExtensionsTests {
    enum TestData {
        static let sizePositiveWidth = CGSize(
            width: 5,
            height: -5
        )
        static let expectedSizePositiveWidth = CGSize(
            width: -5,
            height: 5
        )
        static let sizeNegativeWidth = CGSize(
            width: -5,
            height: 5
        )
        static let expectedSizeNegativeWidth = CGSize(
            width: 5,
            height: -5
        )
    }
}
