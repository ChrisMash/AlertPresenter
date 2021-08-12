//
//  CustomAlertController.swift
//  Created by Chris Mash on 01/07/2021.
//

import UIKit

class CustomAlertController: UIViewController {

    @objc init(title: String) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
        preferredContentSize = CGSize(width: 320, height: 320)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.accessibilityIdentifier = "customAlert"
        #if os(iOS)
        view.backgroundColor = .white
        #else // tvOS
        view.backgroundColor = .black
        #endif
        
        // Create a label
        let label = UILabel()
        label.text = title
        label.textAlignment = .center
        
        // Create a button that will let us dismiss ourselves
        let dismissButton = UIButton(type: .system)
        dismissButton.setTitle("Dismiss", for: .normal)
        #if os(iOS)
        dismissButton.addTarget(self,
                                action: #selector(dismissTapped),
                                for: .touchUpInside)
        #else // tvOS
        dismissButton.addTarget(self,
                                action: #selector(dismissTapped),
                                for: .primaryActionTriggered)
        #endif
        
        // Add them both to a stack view
        let stackView = UIStackView(arrangedSubviews: [
                                                        label,
                                                        dismissButton
                                                      ])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    @objc private func dismissTapped() {
        presentingViewController?.dismiss(animated: true)
    }

}
