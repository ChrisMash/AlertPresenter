import XCTest
@testable import AlertPresenter

class PopoverPresentationTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDefaultInit() throws {
        let presentation = PopoverPresentation(sourceRect: .zero, delegate: nil)
        XCTAssertNil(presentation.sourceRect)
        XCTAssertNil(presentation.delegate)
        XCTAssertEqual(presentation.arrowDirections, UIPopoverArrowDirection.init(rawValue: 0))
    }
    
    func testDefinedInit() throws {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        class MyDelegate: NSObject, PopoverDelegate {}
        let delegate = MyDelegate()
        let presentation = PopoverPresentation(sourceRect: rect, delegate: delegate)
        XCTAssertEqual(presentation.sourceRect, rect)
        let presentationDelegate = try XCTUnwrap(presentation.delegate)
        XCTAssertEqual(String(describing: presentationDelegate), delegate.description)
        XCTAssertEqual(presentation.arrowDirections, UIPopoverArrowDirection.any)
    }

}
