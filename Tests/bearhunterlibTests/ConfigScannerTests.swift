@testable import bearhunterlib
import testsCommon
import XCTest

// swiftlint:disable implicitly_unwrapped_optional
final class ConfigScannerTests: XCTestCase {

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
        let configFiles = locator.configFiles ?? []

        // when
        let repositories = configFiles.compactMap(repositories).flatMap { $0 }

        // then
        XCTAssertEqual(repositories.count, expectation(for: type))
    }

    func test_givenLocatorForNotExistingPath_whenScanRepositories_thenRepositoriesIsEmpty() {
        // given
        let locator = ConfigLocator(directory: Bundle.notExistingPath, type: type)
        let configFiles = locator.configFiles ?? []

        // when
        let repositories = configFiles.compactMap(repositories).flatMap { $0 }

        // then
        XCTAssertTrue(repositories.isEmpty)
    }

    func test_givenLocatorForNoConfigFilesPath_whenScanRepositories_thenRepositoriesIsEmpty() {
        // given
        let locator = ConfigLocator(directory: Bundle.noConfigFilesPath, type: type)
        let configFiles = locator.configFiles ?? []

        // when
        let repositories = configFiles.compactMap(repositories).flatMap { $0 }

        // then
        XCTAssertTrue(repositories.isEmpty)
    }
}

fileprivate extension ConfigScannerTests {
    
    func expectation(for type: DMType) -> Int {
        switch type {
        case .spm: return 1
        case .xcodeproj: return 3
        case .carthage: return 3
        case .gitSubmodules: return 0 // TODO: change when implement corresponding scanner
        case .gitSubtree: return 0 // TODO: change when implement corresponding scanner
        case .cocoapods: return 24
        }
    }
}

fileprivate extension ConfigScannerTests {

    func repositories(from file: ConfigFile) -> Repositories? {
        ConfigScanner(file: file).repositories
    }
}
