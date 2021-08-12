import UIKit
@testable import AlertPresenter

class TestUtils {
    
    static func createAlert() -> UIAlertController {
        UIAlertController(title: "title",
                          message: "message",
                          preferredStyle: .alert)
    }
    
    static func createAlertModel() -> AlertModel {
        let alert = UIAlertController(title: "title",
                                      message: "message",
                                      preferredStyle: .alert)
        if #available(iOS 13.0, tvOS 13.0, *) {
            return AlertModel13(alert: alert,
                                 scene: nil)
        } else {
            return AlertModel(alert: alert)
        }
    }
    
}
