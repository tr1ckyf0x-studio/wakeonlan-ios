import XCTest

@testable import SharedExtensions

final class StringExtensionsTests: XCTestCase {
    func testMatches() {
        assert(TestData.testString.matches(TestData.testString), "Matches function must return true")
    }
}

private extension StringExtensionsTests {
    enum TestData {
        static let testString = UUID().uuidString
    }
}
