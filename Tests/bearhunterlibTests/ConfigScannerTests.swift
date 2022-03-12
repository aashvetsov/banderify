@testable import bearhunterlib
import testsCommon
import XCTest

// swiftlint:disable implicitly_unwrapped_optional
final class ConfigScannerTests: XCTestCase {

    private var expectations: [DMType: Int] {[
        .spm: 1,
        .xcodeproj: 3,
        .carthage: 3,
        .gitSubmodules: 0, // TODO: change when implement corresponding scanneer
        .gitSubtree: 0, // TODO: change when implement corresponding scanneer
        .cocoapods: 0 // TODO: change when implement corresponding scanneer
    ]}

    private var type: DMType!

    override func invokeTest() {
        DMType.allCases.forEach {
            type = $0
            super.invokeTest()
        }
    }

    override func tearDown() {
        type = nil
        super.tearDown()
    }

    func test_givenLocatorForAllDMsPath_whenScanComponents_thenComponentsCountEqualExpectations() {
        // given
        let locator = ConfigLocator(directory: Bundle.allDMsPath, type: type)

        // when
        let components = locator.configFiles.flatMap(components(from:))

        // then
        XCTAssertEqual(components.count, expectations[type])
    }

    func test_givenLocatorForNotExistingPath_whenScanComponents_thenComponentsIsEmpty() {
        // given
        let locator = ConfigLocator(directory: Bundle.notExistingPath, type: type)

        // when
        let components = locator.configFiles.flatMap(components(from:))

        // then
        XCTAssertTrue(components.isEmpty)
    }

    func test_givenLocatorForNoConfigFilesPath_whenScanComponents_thenComponentsIsEmpty() {
        // given
        let locator = ConfigLocator(directory: Bundle.noConfigFilesPath, type: type)

        // when
        let components = locator.configFiles.flatMap(components(from:))

        // then
        XCTAssertTrue(components.isEmpty)
    }
}

fileprivate extension ConfigScannerTests {

    func components(from file: ConfigFile) -> ComponentsSet {
        ConfigScanner(file: file).components
    }
}
