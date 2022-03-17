import bearhuntercli
import testsCommon
import XCTest

final class BearhunterScanCommandPositiveTests: XCTestCase {

    func test_givenValidLongArgumentsWithAllDMs_whenCallCommandExecute_thenRepositoriesIsEmptyFalseTestErrorIsNil() {
        var repositories: BearhunterScanCommand.Output?
        var testError: Error?

        // given
        let arguments = ["--path", Bundle.allDMsPath]

        // when
        do { repositories = try BearhunterScanCommand.execute(with: arguments) } catch { testError = error }

        // then
        if let repositories = repositories {
            XCTAssertFalse(repositories.isEmpty)
        } else {
            XCTFail("Repositories not found")
        }
        XCTAssertNil(testError)
    }

    func test_givenValidShortArgumentsWithAllDMs_whenCallCommandExecute_thenRepositoriesIsEmptyFalseTestErrorIsNil() {
        var repositories: BearhunterScanCommand.Output?
        var testError: Error?

        // given
        let arguments = ["-p", Bundle.allDMsPath]

        // when
        do { repositories = try BearhunterScanCommand.execute(with: arguments) } catch { testError = error }

        // then
        if let repositories = repositories {
            XCTAssertFalse(repositories.isEmpty)
        } else {
            XCTFail("Repositories not found")
        }
        XCTAssertNil(testError)
    }
}
