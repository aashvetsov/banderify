import bearhuntercli
import testsCommon
import XCTest

final class BearhunterScanCommandNegativeTests: XCTestCase {

    private var arguments: [String]?
    private let configurations: [[String]] = [
        ["--path", "/not_exisiting"],
        ["--path"],
        ["-p", "/not_exisiting"],
        ["-p"],
        [""],
        ["--unsupportedArgument"]
    ]

    override func invokeTest() {
        configurations.forEach {
            arguments = $0
            super.invokeTest()
        }
    }

    override func tearDown() {
        arguments = nil
        super.tearDown()
    }

    func test_whenCallCommandExecuteWithInvalidArguments_thenOutputIsNilErrorIsNotNil() {
        var repositories: BearhunterScanCommand.Output?
        var testError: Error?

        // when
        do { repositories = try BearhunterScanCommand.execute(with: arguments) } catch { testError = error }

        // then
        XCTAssertNil(repositories)
        XCTAssertNotNil(testError)
    }
}
