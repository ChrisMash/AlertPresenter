//
//  ViewController.swift
//  Created by Chris Mash on 06/07/2021.
//

import UIKit
import AlertPresenter

class ViewController: UIViewController {

    // Store an instance of AlertPresenter
    private let alertPresenter = AlertPresenter()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Grab the window scene (likely required on iOS 13+)
        guard let windowScene = view.window?.windowScene else {
            fatalError("Failed to get windowScene")
        }
        
        // Queue up two alerts to see them appear one after the other
        alertPresenter.enqueue(alert: createAlert(index: 1),
                               windowScene: windowScene)
        alertPresenter.enqueue(alert: createAlert(index: 2),
                               windowScene: windowScene)
    }
    
    private func createAlert(index: Int) -> UIAlertController {
        let alert = UIAlertController(title: "alert \(index)",
                                      message: "message \(index)",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "dismiss",
                                      style: .default))
        return alert
    }

}
