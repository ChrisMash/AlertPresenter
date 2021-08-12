import XCTest
@testable import AlertPresenter

final class ContainerViewControllerTests: XCTestCase {
    
    func testInit() throws {
        let vc = ContainerViewController(with: TestUtils.createAlert(),
                                         popoverPresentation: nil,
                                         onDismiss: {})
        XCTAssertEqual(vc.view.backgroundColor, .clear)
    }
    
    func testAppear() throws {
        let alert = TestUtils.createAlert()
        let vc = ContainerViewController(with: alert,
                                         popoverPresentation: nil,
                                         onDismiss: {})
        let window = UIWindow()
        window.rootViewController = vc
        window.makeKeyAndVisible()
        XCTAssertEqual(vc.presentedViewController, alert)
    }
    
    func testPopoverAppearWithoutPresentation() throws {
        let alert = UIViewController()
        // Set the modal style to popover so the popoverPresentationController
        // gets created (even on iPhone)
        #if os(iOS)
        alert.modalPresentationStyle = .popover
        #endif
        let vc = ContainerViewController(with: alert,
                                         popoverPresentation: nil,
                                         onDismiss: {})
        let window = UIWindow()
        window.rootViewController = vc
        window.makeKeyAndVisible()
        
        #if os(iOS)
        let expectedSourceRect = CGRect(x: UIScreen.main.bounds.width / 2.0,
                                        y: UIScreen.main.bounds.height / 2.0,
                                        width: 1,
                                        height: 1)
        XCTAssertEqual(alert.popoverPresentationController?.sourceRect, expectedSourceRect)
        XCTAssertEqual(alert.popoverPresentationController?.permittedArrowDirections, .init(rawValue: 0))
        #else // tvOS
        XCTAssertNil(alert.popoverPresentationController)
        #endif
        XCTAssertEqual(vc.presentedViewController, alert)
    }
    
    #if os(iOS)
    func testPopoverAppearWithPresentation() throws {
        let alert = UIViewController()
        // Set the modal style to popover so the popoverPresentationController
        // gets created (even on iPhone)
        alert.modalPresentationStyle = .popover
        var popoverAlertReceived: UIViewController?
        let popoverExpectation = XCTestExpectation(description: "popoverPresentation closure called")
        let desiredSourceRect = CGRect(x: 20,
                                       y: 20,
                                       width: 10,
                                       height: 10)
        let vc = ContainerViewController(with: alert,
                                         popoverPresentation: { alert in
                                            popoverAlertReceived = alert
                                            popoverExpectation.fulfill()
                                            return PopoverPresentation(sourceRect: desiredSourceRect,
                                                                       delegate: nil)
                                         },
                                         onDismiss: {})
        let window = UIWindow()
        window.rootViewController = vc
        window.makeKeyAndVisible()
        
        wait(for: [popoverExpectation], timeout: 1)
        XCTAssertNotNil(popoverAlertReceived)
        XCTAssertEqual(alert.popoverPresentationController?.sourceRect, desiredSourceRect)
        XCTAssertEqual(alert.popoverPresentationController?.permittedArrowDirections, .any)
        XCTAssertEqual(vc.presentedViewController, alert)
    }
    
    func testPopoverAppearWithPresentationOnRotation() throws {
        let alert = UIViewController()
        // Set the modal style to popover so the popoverPresentationController
        // gets created (even on iPhone)
        alert.modalPresentationStyle = .popover
        let popoverExpectation = XCTestExpectation(description: "popoverPresentation closure called")
        popoverExpectation.expectedFulfillmentCount = 2
        popoverExpectation.assertForOverFulfill = true
        let desiredSourceRect1 = CGRect(x: 20,
                                        y: 20,
                                        width: 10,
                                        height: 10)
        let desiredSourceRect2 = CGRect(x: 40,
                                        y: 40,
                                        width: 20,
                                        height: 20)
        var closureCallCount = 0
        let vc = ContainerViewController(with: alert,
                                         popoverPresentation: { alert in
                                            popoverExpectation.fulfill()
                                            let rect = closureCallCount == 0 ? desiredSourceRect1 : desiredSourceRect2
                                            closureCallCount += 1
                                            return PopoverPresentation(sourceRect: rect,
                                                                       delegate: nil)
                                         },
                                         onDismiss: {})
        let window = UIWindow()
        window.rootViewController = vc
        window.makeKeyAndVisible()
        
        XCTAssertEqual(vc.presentedViewController, alert)
        
        XCTAssertEqual(alert.popoverPresentationController?.sourceRect, desiredSourceRect1)
        XCTAssertEqual(alert.popoverPresentationController?.permittedArrowDirections, .any)
        
        vc.onAppearanceChange(to: .zero)
        
        wait(for: [popoverExpectation], timeout: 2)
        
        XCTAssertEqual(alert.popoverPresentationController?.sourceRect, desiredSourceRect2)
        XCTAssertEqual(alert.popoverPresentationController?.permittedArrowDirections, .any)
    }
    #endif // os(iOS)
    
    func testDismiss() throws {
        let alert = TestUtils.createAlert()
        let dismissExp = expectation(description: "onDismiss called")
        let vc = ContainerViewController(with: alert,
                                         popoverPresentation: nil,
                                         onDismiss: {
            dismissExp.fulfill()
        })
        let window = UIWindow()
        window.rootViewController = vc
        window.makeKeyAndVisible()
        alert.beginAppearanceTransition(true, animated: true)
        alert.endAppearanceTransition()
        _ = XCTWaiter.wait(for: [expectation(description:"just wait")],
                           timeout: 2)
        let completionExp = expectation(description: "completion called")
        vc.dismiss(animated: false, completion: {
            completionExp.fulfill()
        })
        wait(for: [dismissExp, completionExp], timeout: 2)
    }
    
    func testAppearWithCustomAlert() throws {
        let alert = UIViewController()
        let vc = ContainerViewController(with: alert,
                                         popoverPresentation: nil,
                                         onDismiss: {})
        let window = UIWindow()
        window.makeKeyAndVisible()
        window.rootViewController = vc
        XCTAssertEqual(vc.presentedViewController, alert)
    }
    
}

