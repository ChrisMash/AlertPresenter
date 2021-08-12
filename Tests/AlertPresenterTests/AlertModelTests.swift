import XCTest
@testable import AlertPresenter

class AlertModelTests: XCTestCase {

    func testInitAlertModel() throws {
        let alert = UIViewController()
        let model = AlertModel(alert: alert)
        XCTAssertEqual(model.alert, alert)
    }
    
    func testInitAlertModel13() throws {
        if #available(iOS 13.0, tvOS 13.0, *) {
            let alert = UIViewController()
            let model = AlertModel13(alert: alert, scene: nil)
            XCTAssertEqual(model.alert, alert)
            XCTAssertEqual(model.scene, nil)
        }
        else {
            NSLog("Skipping \(#function) on OS version prior to 13.0")
        }
    }

}
