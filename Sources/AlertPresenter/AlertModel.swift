//
//  AlertModel.swift
//  Created by Chris Mash on 19/05/2021.
//

import UIKit

internal class AlertModel {
    let alert: UIViewController
    let popoverPresentation: AlertPresenter.PopoverPresentationClosure?

    init(alert: UIViewController,
         popoverPresentation: AlertPresenter.PopoverPresentationClosure? = nil) {
        self.alert = alert
        self.popoverPresentation = popoverPresentation
    }
}

@available(iOS 13.0, tvOS 13.0, *)
internal class AlertModel13: AlertModel {
    let scene: UIWindowScene?

    init(alert: UIViewController,
         scene: UIWindowScene?,
         popoverPresentation: AlertPresenter.PopoverPresentationClosure? = nil) {
        self.scene = scene
        super.init(alert: alert,
                   popoverPresentation: popoverPresentation)
    }
}
