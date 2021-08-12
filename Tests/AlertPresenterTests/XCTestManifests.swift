import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(AlertModelTests.allTests),
        testCase(AlertPresenterTests.allTests),
        testCase(AlertWindowTests.allTests),
        testCase(ContainerViewControllerTests.allTests),
        testCase(PopoverPresentationTests.allTests),
        testCase(QueueTests.allTests)
    ]
}
#endif
