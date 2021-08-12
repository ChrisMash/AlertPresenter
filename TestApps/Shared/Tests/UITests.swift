//
//  UITests.swift
//  Created by Chris Mash on 09/05/2021.
//

import XCTest

class UITests: XCTestCase {
    
    private let appearTimeout = 2.0
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        #if os(iOS)
        XCUIDevice.shared.orientation = .portrait
        #endif
        
        continueAfterFailure = false
        app.launch()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        #if os(iOS)
        XCUIDevice.shared.orientation = .portrait
        #endif
    }
    
    func testTwoAlertsQueued() throws {
        XCTContext.runActivity(named: "tap the Show Alerts button") { _ in
            let button = app.buttons["Show Alerts"]
            XCTAssertTrue(button.waitForExistence(timeout: appearTimeout))
            button.xplatformTap(buttonColumn: app.buttons)
        }
        
        XCTContext.runActivity(named: "check the first alert appears") { _ in
            var alert = app.alerts["alert title 1"]
            XCTAssertTrue(alert.waitForExistence(timeout: appearTimeout))
            
            XCTAssertTrue(positionCorrect(alert: alert))
            
            #if os(iOS)
            XCTContext.runActivity(named: "rotate the device") { _ in
                XCUIDevice.shared.orientation = .landscapeLeft
            }
            
            XCTContext.runActivity(named: "check the first alert is positioned correctly post-rotate") { _ in
                alert = app.alerts["alert title 1"]
                XCTAssertTrue(alert.waitForExistence(timeout: appearTimeout))
                
                XCTAssertTrue(positionCorrect(alert: alert))
            }
            #endif // os(iOS)
            
            XCTContext.runActivity(named: "dimiss the first alert") { _ in
                alert.buttons["ok"].xplatformTap()
            }
        }
        
        XCTContext.runActivity(named: "check the second alert appears") { _ in
            let alert = app.alerts["alert title 2"]
            XCTAssertTrue(alert.waitForExistence(timeout: appearTimeout))
            
            XCTAssertTrue(positionCorrect(alert: alert))
            
            XCTContext.runActivity(named: "dimiss the second alert") { _ in
                #if os(tvOS)
                // second alert needs a pause before trying to dismiss
                XCTestCase.wait(for: 1)
                #endif
                
                alert.buttons["ok"].xplatformTap()
            }
        }
        
        XCTContext.runActivity(named: "check no more alerts") { _ in
            // wait for any extra alerts to (erroneously) popup
            XCTestCase.wait(for: appearTimeout)
            XCTAssertEqual(app.alerts.count, 0)
        }
    }
    
    func testTwoActionSheetsQueued() throws {
        XCTContext.runActivity(named: "tap the Show Action Sheets button") { _ in
            let button = app.buttons["Show Action Sheets"]
            XCTAssertTrue(button.waitForExistence(timeout: appearTimeout))
            button.xplatformTap(buttonColumn: app.buttons)
        }
        
        XCTContext.runActivity(named: "check the first sheet appears") { _ in
            var sheet = app.sheets["sheet title 1"]
            XCTAssertTrue(sheet.waitForExistence(timeout: appearTimeout))
            
            // Don't expect unpositioned action sheets to have arrows, even on iPad
            XCTAssertNil(app.popoverArrow)
            
            XCTAssertTrue(positionCorrect(actionSheet: sheet))
            
            #if os(iOS)
            XCTContext.runActivity(named: "rotate the device") { _ in
                XCUIDevice.shared.orientation = .landscapeLeft
            }
            
            XCTContext.runActivity(named: "check the first alert is positioned correctly post-rotate") { _ in
                sheet = app.sheets["sheet title 1"]
                XCTAssertTrue(sheet.waitForExistence(timeout: appearTimeout))
                
                XCTAssertTrue(positionCorrect(actionSheet: sheet))
            }
            #endif // os(iOS)
            
            XCTContext.runActivity(named: "dimiss the first sheet") { _ in
                sheet.buttons["ok"].xplatformTap()
            }
        }
        
        XCTContext.runActivity(named: "check the second sheet appears") { _ in
            let sheet = app.sheets["sheet title 2"]
            XCTAssertTrue(sheet.waitForExistence(timeout: appearTimeout))
            
            // Don't expect unpositioned action sheets to have arrows, even on iPad
            XCTAssertNil(app.popoverArrow)
            
            XCTAssertTrue(positionCorrect(actionSheet: sheet))
            
            XCTContext.runActivity(named: "dimiss the second sheet") { _ in
                #if os(tvOS)
                // second alert needs a pause before trying to dismiss
                XCTestCase.wait(for: 1)
                #endif
                
                sheet.buttons["ok"].xplatformTap()
            }
        }
        
        XCTContext.runActivity(named: "check no more sheets") { _ in
            // wait for any extra sheets to (erroneously) popup
            XCTestCase.wait(for: appearTimeout)
            XCTAssertEqual(app.sheets.count, 0)
        }
    }
    
    #if os(iOS)
    func testTwoPositionedActionSheetsQueued() throws {
        let button = app.buttons["Show Action Sheets Positioned"]
        var buttonFrame = button.frame
        
        XCTContext.runActivity(named: "tap the Show Action Sheets button") { _ in
            XCTAssertTrue(button.waitForExistence(timeout: appearTimeout))
            button.xplatformTap(buttonColumn: app.buttons)
        }
        
        XCTContext.runActivity(named: "check the first sheet appears") { _ in
            var sheet = app.sheets["positioned sheet title 1"]
            XCTAssertTrue(sheet.waitForExistence(timeout: appearTimeout))
            
            XCTAssertTrue(positionCorrect(positionedActionSheet: sheet,
                                          sourceFrame: buttonFrame))
            
            XCTContext.runActivity(named: "rotate the device") { _ in
                XCUIDevice.shared.orientation = .landscapeLeft
                buttonFrame = button.frame
            }
            
            XCTContext.runActivity(named: "check the first alert is positioned correctly post-rotate") { _ in
                sheet = app.sheets["positioned sheet title 1"]
                XCTAssertTrue(sheet.waitForExistence(timeout: appearTimeout))
                
                XCTAssertTrue(positionCorrect(positionedActionSheet: sheet,
                                              sourceFrame: buttonFrame))
            }
            
            XCTContext.runActivity(named: "dimiss the first sheet") { _ in
                sheet.buttons["ok"].xplatformTap()
            }
        }
        
        XCTContext.runActivity(named: "check the second sheet appears") { _ in
            let sheet = app.sheets["positioned sheet title 2"]
            XCTAssertTrue(sheet.waitForExistence(timeout: appearTimeout))
            
            XCTAssertTrue(positionCorrect(positionedActionSheet: sheet,
                                          sourceFrame: buttonFrame))
            
            XCTContext.runActivity(named: "dimiss the second sheet") { _ in
                sheet.buttons["ok"].xplatformTap()
            }
        }
        
        XCTContext.runActivity(named: "check no more sheets") { _ in
            // wait for any extra sheets to (erroneously) popup
            XCTestCase.wait(for: appearTimeout)
            XCTAssertEqual(app.sheets.count, 0)
        }
    }
    #endif // os(iOS)
    
    func testTwoCustomAlertsQueued() throws {
        XCTContext.runActivity(named: "tap the Show Custom Alerts button") { _ in
            let button = app.buttons["Show Custom Alerts"]
            XCTAssertTrue(button.waitForExistence(timeout: appearTimeout))
            button.xplatformTap(buttonColumn: app.buttons)
        }
        
        XCTContext.runActivity(named: "check the first alert appears") { _ in
            var alert = app.otherElements["customAlert"]
            XCTAssertTrue(alert.waitForExistence(timeout: appearTimeout))
            let label = alert.staticTexts["custom title 1"]
            XCTAssertTrue(label.exists)
            
            XCTAssertTrue(positionCorrect(customAlert: alert))
            
            #if os(iOS)
            XCTContext.runActivity(named: "rotate the device") { _ in
                XCUIDevice.shared.orientation = .landscapeLeft
            }
            
            XCTContext.runActivity(named: "check the first alert is positioned correctly post-rotate") { _ in
                alert = app.otherElements["customAlert"]
                XCTAssertTrue(alert.waitForExistence(timeout: appearTimeout))
                
                XCTAssertTrue(positionCorrect(customAlert: alert))
            }
            #endif // iOS
            
            XCTContext.runActivity(named: "dimiss the first alert") { _ in
                let button = alert.buttons["Dismiss"]
                button.xplatformTap()
            }
        }
        
        XCTContext.runActivity(named: "check the second alert appears") { _ in
            let alert = app.otherElements["customAlert"]
            XCTAssertTrue(alert.waitForExistence(timeout: appearTimeout))
            let label = alert.staticTexts["custom title 2"]
            XCTAssertTrue(label.exists)
            
            XCTAssertTrue(positionCorrect(customAlert: alert))
            
            XCTContext.runActivity(named: "dimiss the second alert") { _ in
                let button = alert.buttons["Dismiss"]
                button.xplatformTap()
            }
        }
        
        XCTContext.runActivity(named: "check no more alerts") { _ in
            // wait for any extra alerts to (erroneously) popup
            XCTestCase.wait(for: appearTimeout)
            XCTAssertFalse(app.otherElements["customAlert"].firstMatch.exists)
        }
    }
    
    #if os(iOS)
    func testTwoPositionedCustomAlertsQueued() throws {
        let button = app.buttons["Show Custom Alerts Positioned"]
        var buttonFrame = button.frame
        
        XCTContext.runActivity(named: "tap the Show Custom Alerts button") { _ in
            XCTAssertTrue(button.waitForExistence(timeout: appearTimeout))
            button.xplatformTap(buttonColumn: app.buttons)
        }
        
        XCTContext.runActivity(named: "check the first alert appears") { _ in
            var alert = app.otherElements["customAlert"]
            XCTAssertTrue(alert.waitForExistence(timeout: appearTimeout))
            let label = alert.staticTexts["positioned custom title 1"]
            XCTAssertTrue(label.exists)
            
            XCTAssertTrue(positionCorrect(popover: alert,
                                          sourceFrame: buttonFrame))
            
            XCTContext.runActivity(named: "rotate the device") { _ in
                XCUIDevice.shared.orientation = .landscapeLeft
                buttonFrame = button.frame
            }
            
            XCTContext.runActivity(named: "check the first alert is positioned correctly post-rotate") { _ in
                alert = app.otherElements["customAlert"]
                XCTAssertTrue(alert.waitForExistence(timeout: appearTimeout))
                
                XCTAssertTrue(positionCorrect(popover: alert,
                                              sourceFrame: buttonFrame))
            }
            
            XCTContext.runActivity(named: "dimiss the first alert") { _ in
                let button = alert.buttons["Dismiss"]
                button.xplatformTap()
            }
        }
        
        XCTContext.runActivity(named: "check the second alert appears") { _ in
            let alert = app.otherElements["customAlert"]
            XCTAssertTrue(alert.waitForExistence(timeout: appearTimeout))
            let label = alert.staticTexts["positioned custom title 2"]
            XCTAssertTrue(label.exists)
            
            XCTAssertTrue(positionCorrect(popover: alert,
                                          sourceFrame: buttonFrame))
            
            XCTContext.runActivity(named: "dimiss the second alert") { _ in
                let button = alert.buttons["Dismiss"]
                button.xplatformTap()
            }
        }
        
        XCTContext.runActivity(named: "check no more alerts") { _ in
            // wait for any extra alerts to (erroneously) popup
            XCTestCase.wait(for: appearTimeout)
            XCTAssertFalse(app.otherElements["customAlert"].firstMatch.exists)
        }
    }
    
    func testTwoPositionedCustomAlertsQueuedDismissViaTap() throws {
        let button = app.buttons["Show Custom Alerts Positioned"]
        let buttonFrame = button.frame
        
        XCTContext.runActivity(named: "tap the Show Custom Alerts button") { _ in
            XCTAssertTrue(button.waitForExistence(timeout: appearTimeout))
            button.xplatformTap(buttonColumn: app.buttons)
        }
        
        XCTContext.runActivity(named: "check the first alert appears") { _ in
            let alert = app.otherElements["customAlert"]
            XCTAssertTrue(alert.waitForExistence(timeout: appearTimeout))
            let label = alert.staticTexts["positioned custom title 1"]
            XCTAssertTrue(label.exists)
            
            XCTAssertTrue(positionCorrect(popover: alert,
                                          sourceFrame: buttonFrame))
            
            XCTContext.runActivity(named: "dimiss the first alert by tap") { _ in
                let dismissRegion = app.otherElements["PopoverDismissRegion"]
                dismissRegion.tap()
            }
        }
        
        XCTContext.runActivity(named: "check the second alert appears") { _ in
            let alert = app.otherElements["customAlert"]
            XCTAssertTrue(alert.waitForExistence(timeout: appearTimeout))
            let label = alert.staticTexts["positioned custom title 2"]
            XCTAssertTrue(label.exists)
            
            XCTAssertTrue(positionCorrect(popover: alert,
                                          sourceFrame: buttonFrame))
            
            XCTContext.runActivity(named: "dimiss the second alert") { _ in
                let dismissRegion = app.otherElements["PopoverDismissRegion"]
                dismissRegion.tap()
            }
        }
        
        XCTContext.runActivity(named: "check no more alerts") { _ in
            // wait for any extra alerts to (erroneously) popup
            XCTestCase.wait(for: appearTimeout)
            XCTAssertFalse(app.otherElements["customAlert"].firstMatch.exists)
        }
    }
    #endif // os(iOS)
    
    // MARK: Private functions
    private func positionCorrect(alert: XCUIElement) -> Bool {
        #if os(iOS)
        return alert.frame.contains(app.orientedFrame.center)
        #else // tvOS
        let alertParent = app.otherElements.containing(.alert,
                                                       identifier: nil).firstMatch
        return alertParent.exists
            && alertParent.frame.isModalViewFrame(screenBounds: app.orientedFrame.size)
        #endif
    }
    
    private func positionCorrect(actionSheet sheet: XCUIElement) -> Bool {
        #if os(iOS)
        if UIDevice.current.userInterfaceIdiom == .pad {
            // unpositioned ipad sheets are in the middle of the screen
            return sheet.frame.contains(app.orientedFrame.center)
        } else {
            return sheet.frame.isBottomSheetFrame(screenBounds: app.orientedFrame.size)
        }
        #else // tvOS
        // The alert itself isn't full screen, but contained within a full screen view
        let sheetParent = app.otherElements.containing(.sheet,
                                                       identifier: nil).firstMatch
        return sheetParent.exists
            && sheetParent.frame.isModalViewFrame(screenBounds: app.orientedFrame.size)
        #endif
    }
    
    private func positionCorrect(positionedActionSheet sheet: XCUIElement,
                                 sourceFrame: CGRect) -> Bool {
        #if os(iOS)
        // only iPads show the action sheets in a popover
        if UIDevice.current.userInterfaceIdiom == .pad {
            return positionCorrect(popover: sheet,
                                   sourceFrame: sourceFrame)
        } else {
            return sheet.frame.isBottomSheetFrame(screenBounds: app.orientedFrame.size)
        }
        #else // tvOS
        return sheet.frame.isModalViewFrame(screenBounds: app.orientedFrame.size)
        #endif
    }
    
    private func positionCorrect(customAlert alert: XCUIElement) -> Bool {
        return alert.frame.isModalViewFrame(screenBounds: app.orientedFrame.size)
    }
    
    private func positionCorrect(popover: XCUIElement,
                                 sourceFrame: CGRect) -> Bool {
        return sourceFrame.touches(popover.frame, threshold: 14)
        // Attempted to grab the arrow from the popover and ensure it's touching
        // the button. Worked well on everything except for iPad 14.5 UIKit test app
        // where it reported the arrow was on the other side of the popover
//        guard let arrow = app.popoverArrow else {
//            return false
//        }
//        return arrow.exists
//                && sourceFrame.touches(arrow.frame)
    }
    
}
