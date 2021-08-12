//
//  ViewController.swift
//  Created by Chris Mash on 12/03/2021.
//

import UIKit
import AlertPresenter

class ViewController: UIViewController {
    
    private let alertPresenter = AlertPresenter()
    private let displayInfo: String
    
    init(displayInfo: String) {
        self.displayInfo = displayInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        // Create a label with the title of the view controller
        let label = UILabel()
        label.text = displayInfo
        
        // Create buttons to show different types of alerts
        var buttons = [UIButton]()
        for type in AlertType.allCases {
        let button = UIButton(type: .system)
            button.addTarget(self,
                             action: #selector(showAlertControllersPressed(button:)),
                             for: .touchUpInside)
            button.tag = type.rawValue
            button.setTitle(type.buttonTitle(), for: .normal)
            buttons.append(button)
        }
        
        // Add them all to a stack view
        let stackView = UIStackView(arrangedSubviews: [label] + buttons)
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    @objc private func showAlertControllersPressed(button: UIButton) {
        // The button's tag is an AlertType
        guard let type = AlertType(rawValue: button.tag) else {
            fatalError("unexpected alert type: \(button.tag)")
        }
        
        let alert1 = type.alert(index: 1)
        let alert2 = type.alert(index: 2)
        
        // Provide a presentation closure for popovers.
        // For action sheets this only works on iPad, though a custom
        // alert can be presented as a popover on iOS.
        // The popover presentation style does not exist on tvOS.
        let presentation: AlertPresenter.PopoverPresentationClosure?
        switch type {
        case .alert, .actionSheet, .custom:
            presentation = nil
        case .actionSheetPositioned, .customPositioned:
            presentation  = { [weak self] alert in
                guard let self = self else {
                    return PopoverPresentation(sourceRect: .zero,
                                               delegate: nil)
                }
                
                let rect = button.superview?.convert(button.frame, to: self.view) ?? .zero
                return PopoverPresentation(sourceRect: rect,
                                           delegate: self)
            }
            
            alert1.modalPresentationStyle = .popover
            alert2.modalPresentationStyle = .popover
        }
        
        enqueue(alert: alert1,
                popoverPresentation: presentation)
        enqueue(alert: alert2,
                popoverPresentation: presentation)
    }
    
    private func enqueue(alert: UIViewController,
                         popoverPresentation: AlertPresenter.PopoverPresentationClosure?) {
        // If you're supporting xOS 12 still, you'll need something like this.
        // xOS 13 requires the windowScene, xOS 12 does not (as Scene was introduced in xOS 13).
        if #available(iOS 13.0, tvOS 13.0, *) {
            guard let scene = view.window?.windowScene else {
                fatalError("Failed to get windowScene")
            }
            
            alertPresenter.enqueue(alert: alert,
                                   windowScene: scene,
                                   popoverPresentation: popoverPresentation)
        } else {
            // xOS 12
            alertPresenter.enqueue(alert: alert,
                                   popoverPresentation: popoverPresentation)
        }
    }
    
}

extension ViewController: PopoverDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        // Allows custom view controller alert to be presented as a popover on iPhone
        return .none
    }
    
}
