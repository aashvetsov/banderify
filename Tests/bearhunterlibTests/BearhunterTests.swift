@testable import bearhunterlib
import testsCommon
import XCTest

final class BearhunterTests: XCTestCase {

    func test_whenCallScanWithAllDMsPath_thenRepositoriesIsEmptyFalseAndErrorIsNil() {
        var repositories: Repositories?
        var testError: Error?
        
        // when
        do { repositories = try Bearhunter.scan(Bundle.allDMsPath) } catch { testError = error }

        // then
        if let repositories = repositories {
            XCTAssertFalse(repositories.isEmpty)            
            XCTAssertNil(testError)            
        } else {
            XCTFail("Failed to scan reposiroies")
        }
    }

    func test_whenCallScanWIthNotExistingPath_thenRepositoriesIsNilAndTestErrorIsNotNil() {
        var repositories: Repositories?
        var testError: Error?
        
        // when
        do { repositories = try Bearhunter.scan(Bundle.notExistingPath) } catch { testError = error }

        // then
        XCTAssertNil(repositories)
        XCTAssertNotNil(testError)            
    }

    func test_whenCallScanNoConfigFilesPath_thenRepositoriesIsNilAndTestErrorIsNil() {
        var repositories: Repositories?
        var testError: Error?
        
        // when
        do { repositories = try Bearhunter.scan(Bundle.noConfigFilesPath) } catch { testError = error }

        // then
        XCTAssertNil(repositories)
        XCTAssertNil(testError)            
    }
}
