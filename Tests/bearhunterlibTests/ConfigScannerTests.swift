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

    func test_givenLocatorForAllDMsPath_whenScanRepositories_thenRepositoriesCountEqualExpectations() {
        // given
        let locator = ConfigLocator(directory: Bundle.allDMsPath, type: type)

        // when
        let repositories = locator.configFiles.flatMap(repositories(from:))

        // then
        XCTAssertEqual(repositories.count, expectations[type])
    }

    func test_givenLocatorForNotExistingPath_whenScanRepositories_thenRepositoriesIsEmpty() {
        // given
        let locator = ConfigLocator(directory: Bundle.notExistingPath, type: type)

        // when
        let repositories = locator.configFiles.flatMap(repositories(from:))

        // then
        XCTAssertTrue(repositories.isEmpty)
    }

    func test_givenLocatorForNoConfigFilesPath_whenScanRepositories_thenRepositoriesIsEmpty() {
        // given
        let locator = ConfigLocator(directory: Bundle.noConfigFilesPath, type: type)

        // when
        let repositories = locator.configFiles.flatMap(repositories(from:))

        // then
        XCTAssertTrue(repositories.isEmpty)
    }
}

fileprivate extension ConfigScannerTests {

    func repositories(from file: ConfigFile) -> Repositories {
        ConfigScanner(file: file).repositories
    }
}
