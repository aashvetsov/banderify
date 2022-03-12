@testable import bearhunterlib
import testsCommon
import XCTest

final class BearhunterTests: XCTestCase {

    func test_givenAllDMsPath_whenCallScan_thenComponentsIsEmptyFalseAndErrorIsNil() {
        var testError: Error?
        var components: ComponentsSet = []

        // given
        let path = Bundle.allDMsPath

        // when
        do { components = try Bearhunter.scan(path) } catch { testError = error }

        // then
        XCTAssertFalse(components.isEmpty)
        XCTAssertNil(testError)
    }

    func test_givenNotExistingPath_whenCallScan_thenComponentsIsEmptyAndErrorIsNotNil() {
        var testError: Error?
        var components: ComponentsSet = []

        // given
        let path = Bundle.notExistingPath

        // when
        do { components = try Bearhunter.scan(path) } catch { testError = error }

        // then
        XCTAssertTrue(components.isEmpty)
        XCTAssertNotNil(testError)
    }

    func test_givenNoConfigFilesPath_whenCallScan_thenComponentsIsEmptyAndErrorIsNil() {
        var testError: Error?
        var components: ComponentsSet = []

        // given
        let path = Bundle.noConfigFilesPath

        // when
        do { components = try Bearhunter.scan(path) } catch { testError = error }

        // then
        XCTAssertTrue(components.isEmpty)
        XCTAssertNil(testError)
    }
}
