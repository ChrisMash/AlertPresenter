//
//  TestExtensions.swift
//  Created by Chris Mash on 05/06/2021.
//

import XCTest

extension XCTestCase {
    
    static func wait(for timeout: TimeInterval) {
        let waiter = XCTWaiter()
        let exp = XCTestExpectation(description: "wait for specific timeout")
        _ = waiter.wait(for: [exp], timeout: timeout)
    }
    
}

extension XCUIApplication {
    
    // Returns the elements for arrows on popovers
    var popoverArrow: XCUIElement? {
        var matchingElements = [XCUIElement]()
        for i in 0..<otherElements.count {
            let element = otherElements.element(boundBy: i)
            let frame = element.frame
            let dim1: CGFloat = 37
            let dim2: CGFloat = 13
            let dim2Alt: CGFloat = 333
            if (frame.width == dim1 && frame.height == dim2)
                || (frame.width == dim2 && frame.height == dim1)
                || (frame.width == dim1 && frame.height == dim2Alt)
                || (frame.width == dim2Alt && frame.height == dim1) {
                if element.isEnabled {
                    matchingElements.append(element)
                }
            }
        }
        
        if matchingElements.count > 1 {
            if UIDevice.current.systemVersion.contains("13.") {
                // There appear to be more than one arrow-like views that get picked up on iOS 13
                // and the exact dimensions match seems to be a hidden one on the other side of the
                // popover. The one on the correct side has one dimension much larger than expected.
                let iOS13Arrow = matchingElements.first { $0.frame.height == 333 || $0.frame.width == 333 }
                return iOS13Arrow ?? matchingElements[0]
            } else {
                fatalError("Unexpectedly found multiple matches for popover")
            }
        } else if matchingElements.count == 1 {
            return matchingElements[0]
        }
        
        return nil
    }
    
    // frame doesn't change when setting XCUIDevice.shared.orientation.
    // This function returns the correct frame for the current orientation.
    var orientedFrame: CGRect {
        #if os(iOS)
        switch XCUIDevice.shared.orientation {
        case .portrait, .portraitUpsideDown:
            return frame
        case .landscapeLeft, .landscapeRight:
            return CGRect(origin: .zero,
                          size: frame.size.rotated())
        case .faceUp, .faceDown, .unknown:
            return frame
        @unknown default:
            fatalError("unexpected orientation: \(XCUIDevice.shared.orientation.rawValue)")
        }
        #else // tvOS
        return frame
        #endif
    }
    
}

extension XCUIElement {
    
    func xplatformTap(buttonColumn: XCUIElementQuery? = nil) {
        #if os(iOS)
        tap()
        #else // tvOS
        // Find the index of this element in the specific column of buttons (if provided
        let buttonIndex = buttonColumn?.allElementsBoundByIndex.firstIndex { element in
            return element.label == self.label
        } ?? 0
        
        // Press 'down' on the remote that many times, to focus on this element
        for _ in 0..<buttonIndex {
            XCUIRemote.shared.press(.down)
        }
        
        // Press 'select' on the remote to tap the button
        XCUIRemote.shared.press(.select)
        #endif
    }
    
}

extension CGRect {
    
    var center: CGPoint {
        CGPoint(x: midX, y: midY)
    }
    
    func touches(_ other: CGRect, threshold: CGFloat = 1) -> Bool {
        let unionOfBoth = union(other)
        return unionOfBoth.width <= width + other.width + threshold
            && unionOfBoth.height <= height + other.height + threshold
    }
    
    func isModalViewFrame(screenBounds: CGSize) -> Bool {
        #if os(iOS)
        if UIDevice.current.userInterfaceIdiom == .pad {
            // iPad - fairly close to full screen, but small padding on all sides
            let maxHorizontalPadding: CGFloat = XCUIDevice.shared.orientation.isLandscape ? 200 : 60
            let maxVerticalPadding: CGFloat = 50
            let xCorrect = minX < maxHorizontalPadding
            let yCorrect = minY < maxVerticalPadding
            let widthCorrect = size.width >= screenBounds.width - (maxHorizontalPadding * 2)
            let heightCorrect = size.height >= screenBounds.height - (maxVerticalPadding * 2)
            
            return xCorrect && yCorrect && widthCorrect && heightCorrect
        } else {
            // iPhone - fills whole screen but small padding at the top
            let xCorrect = minX == 0
            let yCorrect = minY < 60
            let widthCorrect = size.width == screenBounds.width
            let heightCorrect = size.height == screenBounds.height - minY
            
            return xCorrect && yCorrect && widthCorrect && heightCorrect
        }
        #else // tvOS
        return size == screenBounds
        #endif
    }
    
    #if os(iOS)
    func isBottomSheetFrame(screenBounds: CGSize) -> Bool {
        let maxHorizontalPadding: CGFloat = XCUIDevice.shared.orientation.isLandscape ? 160 : 10
        let maxVerticalPadding: CGFloat = 10
        let xCorrect = minX < maxHorizontalPadding
        let yCorrect = screenBounds.height - maxY < maxVerticalPadding
        let widthCorrect = size.width >= screenBounds.width - (maxHorizontalPadding * 2)
        let heightCorrect = size.height < 150
        
        return xCorrect && yCorrect && widthCorrect && heightCorrect
    }
    #endif // iOS
    
}

extension CGSize {
    
    func rotated() -> CGSize {
        return CGSize(width: height, height: width)
    }
    
}
