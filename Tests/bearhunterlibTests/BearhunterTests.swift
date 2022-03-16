@testable import bearhunterlib
import testsCommon
import XCTest

final class BearhunterTests: XCTestCase {

    func test_givenAllDMsPath_whenCallScan_thenRepositoriesIsEmptyFalseAndErrorIsNil() {
        var repositories: Repositories?
        var testError: Error?
        
        // given
        let path = Bundle.allDMsPath

        // when
        do { repositories = try Bearhunter.scan(path) } catch { testError = error }

        // then
        if let repositories = repositories {
            XCTAssertFalse(repositories.isEmpty)            
            XCTAssertNil(testError)            
        } else {
            XCTFail("Failed to scan reposiroies")
        }
    }

    func test_givenNotExistingPath_whenCallScan_thenRepositoriesIsNilAndTestErrorIsNotNil() {
        var repositories: Repositories?
        var testError: Error?
        
        // given
        let path = Bundle.notExistingPath

        // when
        do { repositories = try Bearhunter.scan(path) } catch { testError = error }

        // then
        XCTAssertNil(repositories)
        XCTAssertNotNil(testError)            
    }

    func test_givenNoConfigFilesPath_whenCallScan_thenRepositoriesIsNilAndTestErrorIsNil() {
        var repositories: Repositories?
        var testError: Error?
        
        // given
        let path = Bundle.noConfigFilesPath

        // when
        do { repositories = try Bearhunter.scan(path) } catch { testError = error }

        // then
        XCTAssertNil(repositories)
        XCTAssertNil(testError)            
    }
}
