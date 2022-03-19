@testable import bearhunterlib
import testsCommon
import XCTest

// swiftlint:disable implicitly_unwrapped_optional
final class FileFinderTests: XCTestCase {

    private typealias Configuration = (String, String, Bool)

    private let configurations: [Configuration] = [
        ("project.xcodeproj/project.xcworkspace/xcshareddata/swiftpm", "Podfile", false),
        ("project.xcodeproj/project.xcworkspace/xcuserdata", "project.xcodeproj", false),
        ("project.xcodeproj/project.xcworkspace/xcuserdata", ".xcodeproj", false),
        ("project.xcodeproj/xcshareddata", "project.xcodeproj", false),
        ("project.xcodeproj/xcshareddata", ".xcodeproj", false),
        ("test/project.xcodeproj", "project.xcodeproj", true),
        ("test/project.xcodeproj", ".xcodeproj", true),
        ("project.xcodeproj", "project.xcodeproj", true),
        ("project.xcodeproj", ".xcodeproj", true),
        ("/Users/iuada0h5/.cocoapods/repos/qulix/1.0.0/ios_utils.podspec", "ios_utils.podspec", true),
        ("/Users/iuada0h5/.cocoapods/repos/qulix/1.0.0/ios_ui.podspec", "ios_utils.podspec", false),
        ("/Users/iuada0h5/.cocoapods/repos/qulix/1.0.0/ios_utils.podspec", ".podspec", true)
    ]

    private var configuration: Configuration!

    override func invokeTest() {
        configurations.forEach {
            configuration = $0
            super.invokeTest()
        }
    }

    override func tearDown() {
        configuration = nil
        super.tearDown()
    }

    func test_givenFileDescriptorsAndExpectation_whenCompare_thenResultMatchesExpectation() {
        // given
        let left = FileDescriptor(string: configuration.0)
        let right = FileDescriptor(string: configuration.1)
        let expectedResult = configuration.2

        // when
        let result = left =~ right

        // then
        XCTAssertEqual(result, expectedResult)
    }
}
