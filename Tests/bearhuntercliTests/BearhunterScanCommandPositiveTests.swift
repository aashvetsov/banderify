@testable import bearhuntercli
import testsCommon
import XCTest

// swiftlint:disable force_unwrapping
final class BearhunterScanCommandPositiveTests: XCTestCase {

    func test_givenValidLongArgumentsWithAllDMs_whenCallCommandExecute_thenRepositoriesIsEmptyFalseTestErrorIsNil() {
        var testError: Error?

        // given
        let arguments = ["--path", Bundle.allDMsPath]

        // when
        do { try BearhunterScanCommand.execute(with: arguments) } catch { testError = error }

        // then
        let repositories = BearhunterScanCommand.output!
        XCTAssertFalse(repositories.isEmpty)
        XCTAssertNil(testError)
    }

    func test_givenValidShortArgumentsWithAllDMs_whenCallCommandExecute_thenRepositoriesIsEmptyFalseTestErrorIsNil() {
        var testError: Error?

        // given
        let arguments = ["-p", Bundle.allDMsPath]

        // when
        do { try BearhunterScanCommand.execute(with: arguments) } catch { testError = error }

        // then
        let repositories = BearhunterScanCommand.output!
        XCTAssertFalse(repositories.isEmpty)
        XCTAssertNil(testError)
    }
}
