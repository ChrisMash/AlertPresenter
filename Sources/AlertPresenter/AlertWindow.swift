//
//  AlertWindow.swift
//  Created by Chris Mash on 14/03/2021.
//

import UIKit

internal class AlertWindow: UIWindow {
    
    typealias DismissClosure = () -> Void
    
    private var onDismiss: DismissClosure?
    
    init(with model: AlertModel) {
        if #available(iOS 13.0, tvOS 13.0, *),
           let scene = (model as? AlertModel13)?.scene {
            super.init(windowScene: scene)
        }
        else {
            super.init(frame: UIScreen.main.bounds)
        }
        
        let onDismiss = {
            // When dismissed
            self.resignKeyAndHide()
            self.onDismiss?()
        }
        
        rootViewController = ContainerViewController(with: model.alert,
                                                     popoverPresentation: model.popoverPresentation,
                                                     onDismiss: onDismiss)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("Unavailable")
    }
    
    func present(onDismiss: @escaping DismissClosure) {
        self.onDismiss = onDismiss
        makeKeyAndVisible()
    }
    
    func resignKeyAndHide() {
        resignKey()
        isHidden = true
    }
    
}
