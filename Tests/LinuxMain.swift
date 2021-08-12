import XCTest

import AlertPresenterTests

var tests = [XCTestCaseEntry]()
tests += AlertModelTests.allTests()
tests += AlertPresenterTests.allTests()
tests += AlertWindowTests.allTests()
tests += ContainerViewControllerTests.allTests()
tests += PopoverPresentationTests.allTests()
tests += QueueTests.allTests()
XCTMain(tests)
