@testable import bearhuntercli
import testsCommon
import XCTest

// swiftlint:disable force_unwrapping
final class BearhunterScanCommandPositiveTests: XCTestCase {

    func test_givenValidLongArgumentsWithAllDMs_whenCallCommandExecute_thenComponentsIsEmptyFalseTestErrorIsNil() {
        var testError: Error?

        // given
        let arguments = ["--path", Bundle.allDMsPath]

        // when
        do { try BearhunterScanCommand.execute(with: arguments) } catch { testError = error }

        // then
        let components = BearhunterScanCommand.output!
        XCTAssertFalse(components.isEmpty)
        XCTAssertNil(testError)
    }

    func test_givenValidShortArgumentsWithAllDMs_whenCallCommandExecute_thenComponentsIsEmptyFalseTestErrorIsNil() {
        var testError: Error?

        // given
        let arguments = ["-p", Bundle.allDMsPath]

        // when
        do { try BearhunterScanCommand.execute(with: arguments) } catch { testError = error }

        // then
        let components = BearhunterScanCommand.output!
        XCTAssertFalse(components.isEmpty)
        XCTAssertNil(testError)
    }
}
