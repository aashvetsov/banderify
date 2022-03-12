@testable import bearhunterlib
import testsCommon
import XCTest

final class BearhunterTests: XCTestCase {

    func test_givenAllDMsPath_whenCallScan_thenRepositoriesIsEmptyFalseAndErrorIsNil() {
        var testError: Error?
        var repositories: Repositories = []

        // given
        let path = Bundle.allDMsPath

        // when
        do { repositories = try Bearhunter.scan(path) } catch { testError = error }

        // then
        XCTAssertFalse(repositories.isEmpty)
        XCTAssertNil(testError)
    }

    func test_givenNotExistingPath_whenCallScan_thenRepositoriesIsEmptyAndErrorIsNotNil() {
        var testError: Error?
        var repositories: Repositories = []

        // given
        let path = Bundle.notExistingPath

        // when
        do { repositories = try Bearhunter.scan(path) } catch { testError = error }

        // then
        XCTAssertTrue(repositories.isEmpty)
        XCTAssertNotNil(testError)
    }

    func test_givenNoConfigFilesPath_whenCallScan_thenRepositoriesIsEmptyAndErrorIsNil() {
        var testError: Error?
        var repositories: Repositories = []

        // given
        let path = Bundle.noConfigFilesPath

        // when
        do { repositories = try Bearhunter.scan(path) } catch { testError = error }

        // then
        XCTAssertTrue(repositories.isEmpty)
        XCTAssertNil(testError)
    }
}
