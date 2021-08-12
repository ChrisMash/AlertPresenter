//
//  ContainerViewController.swift
//  Created by Chris Mash on 14/03/2021.
//

import UIKit

internal class ContainerViewController: UIViewController {
    
    typealias DismissClosure = () -> Void
    
    private let alertController: UIViewController
    private let onDismiss: DismissClosure
    private let popoverPresentation: AlertPresenter.PopoverPresentationClosure?
    
    init(with alertController: UIViewController,
         popoverPresentation: AlertPresenter.PopoverPresentationClosure?,
         onDismiss: @escaping DismissClosure) {
        self.alertController = alertController
        self.popoverPresentation = popoverPresentation
        self.onDismiss = onDismiss
        
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("Unavailable")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        onAppearanceChange(to: view.frame.size)
        
        present(alertController,
                animated: animated,
                completion: nil)
    }
    
    override func dismiss(animated: Bool,
                          completion: (() -> Void)? = nil) {
        let onCompletion = {
            completion?()
            self.onDismiss()
        }
        
        if animated {
            super.dismiss(animated: animated, completion: onCompletion)
        }
        else {
            onCompletion()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        onAppearanceChange(to: size)
    }
    
    internal func onAppearanceChange(to newSize: CGSize) {
        #if os(iOS)
        // On iPad action sheets are presented as popovers so need position information
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = view
            // Put the sheet in the middle of the screen by default
            popoverController.sourceRect = CGRect(x: newSize.width / 2.0,
                                                  y: newSize.height / 2.0,
                                                  width: 1,
                                                  height: 1)
            // With no arrows (arrow direction 0 = none)
            popoverController.permittedArrowDirections = .init(rawValue: 0)
            if let popoverPresentation = popoverPresentation {
                let presentationInfo = popoverPresentation(alertController)
                popoverController.delegate = presentationInfo.delegate
                popoverController.permittedArrowDirections = presentationInfo.arrowDirections
                if let sourceRect = presentationInfo.sourceRect,
                   sourceRect != .zero {
                    popoverController.sourceRect = sourceRect
                }
            }
        }
        #endif // os(iOS)
    }
    
}
