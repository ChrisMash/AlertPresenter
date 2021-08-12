import XCTest
@testable import AlertPresenter

class MockAlertPresenter: AlertPresenter {
    var deinitCalled: (() -> Void)?
    deinit { deinitCalled?() }
}

final class AlertPresenterTests: XCTestCase {
    
    func testEnqueue() throws {
        let alertPresenter = AlertPresenter()
        var alertsPresented = [UIViewController]()
        alertPresenter.onAlertPresented = { alertsPresented.append($0) }
        var windowsPresented = [UIWindow]()
        alertPresenter.onWindowPresented = { windowsPresented.append($0) }
        
        let alert = TestUtils.createAlert()
        enqueue(alert: alert, presenter: alertPresenter)
        
        wait(for: 0.1)
        
        XCTAssertEqual(alertsPresented.count, 1)
        XCTAssertEqual(alertsPresented[0], alert)
        
        XCTAssertEqual(windowsPresented.count, 1)
        let presentedWindow = try XCTUnwrap(windowsPresented.first)
        XCTAssertEqual(presentedWindow.rootViewController?.presentedViewController, alert)
        XCTAssertEqual(presentedWindow.windowLevel, .alert)
    }
    
    func testEnqueueTwo() throws {
        let alertPresenter = AlertPresenter()
        var alertsPresented = [UIViewController]()
        alertPresenter.onAlertPresented = { alertsPresented.append($0) }
        var windowsPresented = [UIWindow]()
        alertPresenter.onWindowPresented = { windowsPresented.append($0) }
        var alertsDismissed = [UIViewController]()
        alertPresenter.onAlertDismissed = { alertsDismissed.append($0) }
        var windowsDismissed = [UIWindow]()
        alertPresenter.onWindowDismissed = { windowsDismissed.append($0) }
        
        let alert1 = TestUtils.createAlert()
        enqueue(alert: alert1, presenter: alertPresenter)
        let alert2 = TestUtils.createAlert()
        enqueue(alert: alert2, presenter: alertPresenter)
        
        wait(for: 0.1)
        
        // 2 queued up, only the first presented
        XCTAssertEqual(alertsPresented.count, 1)
        XCTAssertEqual(alertsPresented[0], alert1)
        
        XCTAssertEqual(windowsPresented.count, 1)
        let presentedWindow1 = try XCTUnwrap(windowsPresented.first)
        XCTAssertEqual(presentedWindow1.rootViewController?.presentedViewController, alert1)
        
        let exp = expectation(description: "completionCalled")
        // Dismiss the first alert
        let alert1PresenterVC = try XCTUnwrap(alert1.presentingViewController)
        alert1PresenterVC.dismiss(animated: false) {
            exp.fulfill()
        }
        
        // Wait for it to be dismissed
        waitForExpectations(timeout: 2)
        
        XCTAssertEqual(alertsDismissed.count, 1)
        XCTAssertEqual(alertsDismissed[0], alert1)
        
        XCTAssertEqual(windowsDismissed.count, 1)
        let dismissedWindow1 = try XCTUnwrap(windowsDismissed.first)
        XCTAssertEqual(dismissedWindow1.rootViewController?.presentedViewController, alert1)
        
        wait(for: 0.1)
        
        // Once dismissed, second alert should be presented
        XCTAssertEqual(alertsPresented.count, 2)
        XCTAssertEqual(alertsPresented[1], alert2)
        
        XCTAssertEqual(windowsPresented.count, 2)
        let presentedWindow2 = try XCTUnwrap(windowsPresented.last)
        XCTAssertEqual(presentedWindow2.rootViewController?.presentedViewController, alert2)
        
        let exp2 = expectation(description: "completionCalled")
        // Dismiss the second alert
        let alert2PresenterVC = try XCTUnwrap(alert2.presentingViewController)
        alert2PresenterVC.dismiss(animated: false) {
            exp2.fulfill()
        }
        
        // Wait for it to be dismissed
        waitForExpectations(timeout: 2)
        // Once dismissed, no more should be presented
        XCTAssertEqual(alertsPresented.count, 2)
        XCTAssertEqual(windowsPresented.count, 2)
        
        XCTAssertEqual(alertsDismissed.count, 2)
        XCTAssertEqual(alertsDismissed[1], alert2)
        
        XCTAssertEqual(windowsDismissed.count, 2)
        let dismissedWindow2 = try XCTUnwrap(windowsDismissed.last)
        XCTAssertEqual(dismissedWindow2.rootViewController?.presentedViewController, alert2)
    }
    
    func testEnqueueiOS12() throws {
        let alertPresenter = AlertPresenter()
        var alertsPresented = [UIViewController]()
        alertPresenter.onAlertPresented = { alertsPresented.append($0) }
        var windowsPresented = [UIWindow]()
        alertPresenter.onWindowPresented = { windowsPresented.append($0) }
        
        let alert = TestUtils.createAlert()
        alertPresenter.enqueue(alert: alert)
        
        wait(for: 0.1)
        
        XCTAssertEqual(alertsPresented.count, 1)
        XCTAssertEqual(alertsPresented[0], alert)
        
        XCTAssertEqual(windowsPresented.count, 1)
        let presentedWindow = try XCTUnwrap(windowsPresented.first)
        XCTAssertEqual(presentedWindow.rootViewController?.presentedViewController, alert)
        XCTAssertEqual(presentedWindow.windowLevel, .alert)
    }
    
    func testEnqueueCustom() throws {
        let alertPresenter = AlertPresenter()
        var alertsPresented = [UIViewController]()
        alertPresenter.onAlertPresented = { alertsPresented.append($0) }
        var windowsPresented = [UIWindow]()
        alertPresenter.onWindowPresented = { windowsPresented.append($0) }
        
        let alert = UIViewController()
        enqueue(alert: alert, presenter: alertPresenter)
        
        wait(for: 0.1)
        
        XCTAssertEqual(alertsPresented.count, 1)
        XCTAssertEqual(alertsPresented[0], alert)
        
        XCTAssertEqual(windowsPresented.count, 1)
        let presentedWindow = try XCTUnwrap(windowsPresented.first)
        XCTAssertEqual(presentedWindow.rootViewController?.presentedViewController, alert)
        XCTAssertEqual(presentedWindow.windowLevel, .alert)
    }
    
    func testEnqueueTwoCustom() throws {
        let alertPresenter = AlertPresenter()
        var alertsPresented = [UIViewController]()
        alertPresenter.onAlertPresented = { alertsPresented.append($0) }
        var windowsPresented = [UIWindow]()
        alertPresenter.onWindowPresented = { windowsPresented.append($0) }
        var alertsDismissed = [UIViewController]()
        alertPresenter.onAlertDismissed = { alertsDismissed.append($0) }
        var windowsDismissed = [UIWindow]()
        alertPresenter.onWindowDismissed = { windowsDismissed.append($0) }
        
        let alert1 = UIViewController()
        enqueue(alert: alert1, presenter: alertPresenter)
        let alert2 = UIViewController()
        enqueue(alert: alert2, presenter: alertPresenter)
        
        wait(for: 0.1)
        
        // 2 queued up, only the first presented
        XCTAssertEqual(alertsPresented.count, 1)
        XCTAssertEqual(alertsPresented[0], alert1)
        
        XCTAssertEqual(windowsPresented.count, 1)
        let presentedWindow1 = try XCTUnwrap(windowsPresented.first)
        XCTAssertEqual(presentedWindow1.rootViewController?.presentedViewController, alert1)
        
        let exp = expectation(description: "completionCalled")
        // Dismiss the first alert
        let alert1PresenterVC = try XCTUnwrap(alert1.presentingViewController)
        alert1PresenterVC.dismiss(animated: false) {
            exp.fulfill()
        }
        
        // Wait for it to be dismissed
        waitForExpectations(timeout: 2)
        
        XCTAssertEqual(alertsDismissed.count, 1)
        XCTAssertEqual(alertsDismissed[0], alert1)
        
        XCTAssertEqual(windowsDismissed.count, 1)
        let dismissedWindow1 = try XCTUnwrap(windowsDismissed.first)
        XCTAssertEqual(dismissedWindow1.rootViewController?.presentedViewController, alert1)
        
        wait(for: 0.1)
        
        // Once dismissed, second alert should be presented
        XCTAssertEqual(alertsPresented.count, 2)
        XCTAssertEqual(alertsPresented[1], alert2)
        
        XCTAssertEqual(windowsPresented.count, 2)
        let presentedWindow2 = try XCTUnwrap(windowsPresented.last)
        XCTAssertEqual(presentedWindow2.rootViewController?.presentedViewController, alert2)
        
        let exp2 = expectation(description: "completionCalled")
        // Dismiss the second alert
        let alert2PresenterVC = try XCTUnwrap(alert2.presentingViewController)
        alert2PresenterVC.dismiss(animated: false) {
            exp2.fulfill()
        }
        
        // Wait for it to be dismissed
        waitForExpectations(timeout: 2)
        // Once dismissed, no more should be presented
        XCTAssertEqual(alertsPresented.count, 2)
        XCTAssertEqual(windowsPresented.count, 2)
        
        XCTAssertEqual(alertsDismissed.count, 2)
        XCTAssertEqual(alertsDismissed[1], alert2)
        
        XCTAssertEqual(windowsDismissed.count, 2)
        let dismissedWindow2 = try XCTUnwrap(windowsDismissed.last)
        XCTAssertEqual(dismissedWindow2.rootViewController?.presentedViewController, alert2)
    }
    
    func testEnqueueWithSheetPosition() throws {
        let alertPresenter = AlertPresenter()
        var alertsPresented = [UIViewController]()
        alertPresenter.onAlertPresented = { alertsPresented.append($0) }
        var windowsPresented = [UIWindow]()
        alertPresenter.onWindowPresented = { windowsPresented.append($0) }
        
        let alert = UIViewController()
        // Set the modal style to popover so the popoverPresentationController
        // gets created (even on iPhone)
        #if os(iOS)
        alert.modalPresentationStyle = .popover
        #endif
        var popoverAlertReceived: UIViewController?
        let popoverExpectation = XCTestExpectation(description: "popoverPresentation closure called")
        #if os(tvOS)
        popoverExpectation.isInverted = true
        #endif
        enqueue(alert: alert, presenter: alertPresenter) { alert in
            popoverAlertReceived = alert
            popoverExpectation.fulfill()
            return PopoverPresentation(sourceRect: .zero,
                                       delegate: nil)
        }
        
        wait(for: [popoverExpectation], timeout: 1)
        #if os(iOS)
        XCTAssertNotNil(popoverAlertReceived)
        #else // tvOS
        XCTAssertNil(popoverAlertReceived)
        #endif
        
        XCTAssertEqual(alertsPresented.count, 1)
        XCTAssertEqual(alertsPresented[0], alert)
        
        XCTAssertEqual(windowsPresented.count, 1)
        let presentedWindow = try XCTUnwrap(windowsPresented.first)
        XCTAssertEqual(presentedWindow.rootViewController?.presentedViewController, alert)
        XCTAssertEqual(presentedWindow.windowLevel, .alert)
    }
    
    func testEnqueueFromBackground() throws {
        let alertPresenter = AlertPresenter()
        var alertsPresented = [UIViewController]()
        alertPresenter.onAlertPresented = { alertsPresented.append($0) }
        var windowsPresented = [UIWindow]()
        alertPresenter.onWindowPresented = { windowsPresented.append($0) }
        
        let alert = UIViewController()
        DispatchQueue.global().async {
            self.enqueue(alert: alert, presenter: alertPresenter)
        }
        
        wait(for: 0.1)
        
        XCTAssertEqual(alertsPresented.count, 1)
        XCTAssertEqual(alertsPresented.first, alert)
        
        XCTAssertEqual(windowsPresented.count, 1)
        let presentedWindow = try XCTUnwrap(windowsPresented.first)
        XCTAssertEqual(presentedWindow.rootViewController?.presentedViewController, alert)
        XCTAssertEqual(presentedWindow.windowLevel, .alert)
    }
    
    func testEnqueueMultithread() throws {
        let alertPresenter = AlertPresenter()
        var alertsPresented = [UIViewController]()
        alertPresenter.onAlertPresented = { alertsPresented.append($0) }
        var windowsPresented = [UIWindow]()
        alertPresenter.onWindowPresented = { windowsPresented.append($0) }
        
        let alert = UIViewController()
        DispatchQueue.global().async {
            DispatchQueue.concurrentPerform(iterations: 100) { _ in
                self.enqueue(alert: alert, presenter: alertPresenter)
            }
        }
        
        wait(for: 0.1)
        
        XCTAssertEqual(alertsPresented.count, 1)
        XCTAssertEqual(alertsPresented.first, alert)
        
        XCTAssertEqual(windowsPresented.count, 1)
        let presentedWindow = try XCTUnwrap(windowsPresented.first)
        XCTAssertEqual(presentedWindow.rootViewController?.presentedViewController, alert)
        XCTAssertEqual(presentedWindow.windowLevel, .alert)
    }
    
    func testClearAlerts() throws {
        let alertPresenter = AlertPresenter()
        var windowsPresented = [UIWindow]()
        alertPresenter.onWindowPresented = { windowsPresented.append($0) }
        var alertsDismissed = [UIViewController]()
        alertPresenter.onAlertDismissed = { alertsDismissed.append($0) }
        var windowsDismissed = [UIWindow]()
        alertPresenter.onWindowDismissed = { windowsDismissed.append($0) }
        
        let alert = TestUtils.createAlert()
        enqueue(alert: alert, presenter: alertPresenter)
        
        wait(for: 0.1)
        
        alertPresenter.clearAlerts()
        
        wait(for: 0.1)
        
        let presentedWindow = try XCTUnwrap(windowsPresented.first)
        XCTAssertFalse(presentedWindow.isKeyWindow)
        XCTAssertTrue(presentedWindow.isHidden)
        
        XCTAssertEqual(alertsDismissed.count, 1)
        XCTAssertEqual(alertsDismissed[0], alert)
        
        XCTAssertEqual(windowsDismissed.count, 1)
        let dismissedWindow2 = try XCTUnwrap(windowsDismissed.last)
        XCTAssertEqual(dismissedWindow2.rootViewController?.presentedViewController, alert)
    }
    
    func testDeinit() throws {
        var alertPresenter: MockAlertPresenter? = MockAlertPresenter()
        var alertsPresented = [UIViewController]()
        alertPresenter?.onAlertPresented = { alertsPresented.append($0) }
        var windowsPresented = [UIWindow]()
        alertPresenter?.onWindowPresented = { windowsPresented.append($0) }
        var alertsDismissed = [UIViewController]()
        alertPresenter?.onAlertDismissed = { alertsDismissed.append($0) }
        var windowsDismissed = [UIWindow]()
        alertPresenter?.onWindowDismissed = { windowsDismissed.append($0) }
        
        // Enqueue an alet
        let alert = UIViewController()
        let popoverPresentation: AlertPresenter.PopoverPresentationClosure = { _ in return PopoverPresentation(sourceRect: .zero, delegate: nil)
        }
        enqueue(alert: alert,
                presenter: alertPresenter!,
                popoverPresentation: popoverPresentation)
        
        wait(for: 0.1)
        
        // Check it showed the alert and window
        XCTAssertEqual(alertsPresented.count, 1)
        XCTAssertEqual(windowsPresented.count, 1)
        
        // Dismiss the alert
        let dismissExp = expectation(description: "completionCalled")
        // Dismiss the first alert
        let alert1PresenterVC = try XCTUnwrap(alert.presentingViewController)
        alert1PresenterVC.dismiss(animated: false) {
            dismissExp.fulfill()
        }
        
        // Wait for it to be dismissed
        waitForExpectations(timeout: 2)
        
        // Check it dismissed the alert and window
        XCTAssertEqual(alertsDismissed.count, 1)
        XCTAssertEqual(windowsDismissed.count, 1)
        
        // Deinit the alert presenter
        let deinitExp = expectation(description: "AlertPresenter deinit called")
        alertPresenter?.deinitCalled = {
            deinitExp.fulfill()
        }

        DispatchQueue.global(qos: .background).async {
            alertPresenter = nil
        }

        // Wait for the deinit to be called
        waitForExpectations(timeout: 0.1)
    }
    
    // MARK: Private functions
    private func enqueue(alert: UIViewController,
                         presenter: AlertPresenter,
                         popoverPresentation: AlertPresenter.PopoverPresentationClosure? = nil) {
        if #available(iOS 13.0, tvOS 13.0, *) {
            presenter.enqueue(alert: alert,
                              windowScene: nil,
                              popoverPresentation: popoverPresentation)
        } else {
            presenter.enqueue(alert: alert,
                              popoverPresentation: popoverPresentation)
        }
    }
    
    // MARK: Private functions
    private func wait(for timeout: TimeInterval) {
        _ = XCTWaiter().wait(for: [XCTestExpectation()], timeout: timeout)
    }
    
}
