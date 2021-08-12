//
//  UIAlertControllerExtension.swift
//  Created by Chris Mash on 01/06/2021.
//

import UIKit

@objc extension UIAlertController {
    
    @objc static func basic(title: String,
                      message: String,
                      style: UIAlertController.Style) -> UIAlertController {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: style)
        
        let action = UIAlertAction(title: "ok",
                                   style: .default)
        alert.addAction(action)
        
        return alert
    }
    
}
