import XCTest
@testable import AlertPresenter

final class AlertWindowTests: XCTestCase {
    
    func testInit() throws {
        let window = AlertWindow(with: TestUtils.createAlertModel())
        let rootVC = try XCTUnwrap(window.rootViewController)
        XCTAssertTrue(type(of: rootVC) == ContainerViewController.self)
    }
    
    func testPresent() throws {
        let window = AlertWindow(with: TestUtils.createAlertModel())
        window.present(onDismiss: {})
        XCTAssertTrue(window.isKeyWindow)
        XCTAssertFalse(window.isHidden)
    }
    
    func testResign() throws {
        let window = AlertWindow(with: TestUtils.createAlertModel())
        window.present(onDismiss: {})
        window.resignKeyAndHide()
        XCTAssertFalse(window.isKeyWindow)
        XCTAssertTrue(window.isHidden)
    }
    
    func testDismiss() throws {
        let window = AlertWindow(with: TestUtils.createAlertModel())
        let dismissExp = expectation(description: "onDismiss called")
        window.present(onDismiss: {
            dismissExp.fulfill()
        })
        let rootVC = try XCTUnwrap(window.rootViewController)
        rootVC.dismiss(animated: false, completion: nil)
        waitForExpectations(timeout: 2)
        XCTAssertFalse(window.isKeyWindow)
        XCTAssertTrue(window.isHidden)
    }
    
}

