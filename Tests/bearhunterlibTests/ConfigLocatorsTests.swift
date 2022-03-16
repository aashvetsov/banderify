@testable import bearhunterlib
import testsCommon
import XCTest

// swiftlint:disable implicitly_unwrapped_optional
final class ConfigLocatorsTests: XCTestCase {

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

    func test_givenLocatorForAllDMsPath_whenGetConfigFiles_thenConfigFilesCountEqual1() {
        // given
        let locator = ConfigLocator(directory: Bundle.allDMsPath, type: type)

        // when
        guard let configFiles = locator.configFiles else { XCTFail("No configFiles found"); return }

        // then
        XCTAssertEqual(configFiles.count, 1)
    }

    func test_givenLocatorForNotExistingPath_whenGetConfigFiles_thenConfigFilesIsNil() {
        // given
        let locator = ConfigLocator(directory: Bundle.notExistingPath, type: type)

        // when
        let configFiles = locator.configFiles

        // then
        XCTAssertNil(configFiles)
    }

    func test_givenLocatorForNoConfigFilesPath_whenGetConfigFiles_thenConfigFilesIsNil() {
        // given
        let locator = ConfigLocator(directory: Bundle.noConfigFilesPath, type: type)

        // when
        let configFiles = locator.configFiles

        // then
        XCTAssertNil(configFiles)
    }
}
