//
//  AlertType.swift
//  Created by Chris Mash on 05/07/2021.
//

import UIKit

@objc enum AlertType: Int, CaseIterable {
    case alert
    case actionSheet
    #if os(iOS)
    case actionSheetPositioned
    #endif
    case custom
    #if os(iOS)
    case customPositioned
    #endif
    
    func buttonTitle() -> String {
        return AlertFactory.buttonTitle(forType: self)
    }
    
    func alert(index: UInt) -> UIViewController {
        return AlertFactory.alert(forType: self, index: index)
    }
}

@objc class AlertFactory: NSObject {
    
    @objc static func allAlertTypes() -> [Int] {
        return AlertType.allCases.map{ $0.rawValue }
    }
    
    @objc static func buttonTitle(forType type: AlertType) -> String {
        switch type {
        case .alert:
            return "Show Alerts"
        case .actionSheet:
            return "Show Action Sheets"
        #if os(iOS)
        case .actionSheetPositioned:
            return "Show Action Sheets Positioned"
        #endif
        case .custom:
            return "Show Custom Alerts"
        #if os(iOS)
        case .customPositioned:
            return "Show Custom Alerts Positioned"
        #endif
        }
    }
    
    @objc static func alert(forType type: AlertType, index: UInt) -> UIViewController {
        switch type {
        case .alert:
            return UIAlertController.basic(title: "alert title \(index)",
                                           message: "message \(index)",
                                           style: .alert)
        case .actionSheet:
            return UIAlertController.basic(title: "sheet title \(index)",
                                           message: "message \(index)",
                                           style: .actionSheet)
        #if os(iOS)
        case .actionSheetPositioned:
            return UIAlertController.basic(title: "positioned sheet title \(index)",
                                           message: "message \(index)",
                                           style: .actionSheet)
        #endif
        case .custom:
            return CustomAlertController(title: "custom title \(index)")
        #if os(iOS)
        case .customPositioned:
            return CustomAlertController(title: "positioned custom title \(index)")
        #endif
        }
    }
    
}
