//
//  AlertPresenter.swift
//  Created by Chris Mash on 14/03/2021.
//

import UIKit

/// Queues alerts for presentation in its own window, avoiding conflicts with other presentations and animations.
public class AlertPresenter: NSObject {
    
    /// The closure type for `onAlertPresented`
    public typealias PresentClosure = (UIViewController) -> Void
    /// The closure type for `onAlertDismissed`
    public typealias DismissClosure = (UIViewController) -> Void
    /// The closure type for configuring presentation of popovers, such as action sheets on iPad
    public typealias PopoverPresentationClosure = (UIViewController) -> PopoverPresentation
    
    internal typealias WindowPresentClosure = (UIWindow) -> Void
    internal typealias WindowDismissClosure = (UIWindow) -> Void
    
    private let windowLevel: UIWindow.Level
    private let dispatchQueue = DispatchQueue(label: "com.cm.alertpresenter.concurrency",
                                              qos: .userInteractive)
    private var alertQueue = Queue<AlertModel>()
    private var alertWindow: AlertWindow?
    
    internal var onWindowPresented: WindowPresentClosure?
    internal var onWindowDismissed: WindowDismissClosure?
    
    /// Closure called when an alert is presented
    @objc public var onAlertPresented: PresentClosure?
    /// Closure called when an alert is dismissed
    @objc public var onAlertDismissed: DismissClosure?
    
    /// Creates the `AlertPresenter` with the specified window level.
    ///
    /// - parameter windowLevel: the `UIWindow.Level` to present the alerts at, defaults to `.alert`
    @objc public init(windowLevel: UIWindow.Level = .alert) {
        self.windowLevel = windowLevel
        super.init()
    }

    /// Queues the specified alert for presentation in the specified window scene
    ///
    /// - Warning
    /// you must provide a `UIWindowScene` unless your app does not have a `SceneDelegate` and doesn't
    /// use SwiftUI's `App`.
    ///
    /// - parameter alert: the `UIViewController` (or `UIAlertController`) alert  to be presented
    /// - parameter windowScene: the `UIWindowScene` to present the alert in
    /// - parameter popoverPresentation: optional closure for configuring presentation of popovers, such as
    /// action sheets on iPad. Default behaviour is to display in the center of the screen with no arrows
    @available(iOS 13.0, tvOS 13.0, *)
    @objc(enqueueAlert:windowScene:popoverPresentation:)
    public func enqueue(alert: UIViewController,
                        windowScene: UIWindowScene?,
                        popoverPresentation: PopoverPresentationClosure? = nil) {
        dispatchQueue.async {
            self.enqueue(alertModel: AlertModel13(alert: alert,
                                                  scene: windowScene,
                                                  popoverPresentation: popoverPresentation))
        }
    }
    
    /// Queues the specified alert for presentation.
    ///
    /// - Warning
    /// This function is intended for xOS 12 support and will not work correctly if you have a `SceneDelegate`
    /// in your app or use SwiftUI's `App`.
    ///
    /// - parameter alert: the `UIViewController` (or `UIAlertController`) alert  to be presented
    /// - parameter popoverPresentation: optional closure for configuring presentation of action sheets on iPad.
    /// Default behaviour is to display in the center of the screen with no arrows
    @available(iOS, deprecated: 13.0, message: "use enqueue(alert:windowScene:popoverPresentation)")
    @available(tvOS, deprecated: 13.0, message: "use enqueue(alert:windowScene:popoverPresentation)")
    @objc(enqueueAlert:popoverPresentation:)
    public func enqueue(alert: UIViewController,
                        popoverPresentation: PopoverPresentationClosure? = nil) {
        dispatchQueue.async {
            self.enqueue(alertModel: AlertModel(alert: alert,
                                                popoverPresentation: popoverPresentation))
        }
    }
    
    /// Clears any enqueued alerts and dismisses the currently displaying alert (if any).
    @objc public func clearAlerts() {
        dispatchQueue.async {
            self.alertQueue = Queue<AlertModel>()
            
            if let currentWindow = self.alertWindow {
                DispatchQueue.main.async {
                    self.onWindowDismissed?(currentWindow)
                    
                    if let rootVC = currentWindow.rootViewController,
                       let presentedVC = rootVC.presentedViewController {
                        self.onAlertDismissed?(presentedVC)
                    }
                    
                    self.alertWindow?.resignKeyAndHide()
                    self.alertWindow = nil
                }
            }
        }
    }
    
    // MARK: Private functions
    private func enqueue(alertModel: AlertModel) {
        alertQueue.enqueue(alertModel)
        
        // If there's no alert currently showing, show this one
        if alertWindow == nil {
            showNextAlertIfPresent()
        }
    }

    private func showNextAlertIfPresent() {
        guard let model = alertQueue.dequeue() else {
            return
        }

        DispatchQueue.main.sync {
            let alertWindow = AlertWindow(with: model)
            alertWindow.windowLevel = windowLevel
            alertWindow.present { [weak self] in
                // When dismissed
                self?.onWindowDismissed?(alertWindow)
                self?.onAlertDismissed?(model.alert)
                self?.alertWindow = nil
                
                self?.dispatchQueue.async {
                    self?.showNextAlertIfPresent()
                }
            }
            
            self.alertWindow = alertWindow
            
            onWindowPresented?(alertWindow)
            onAlertPresented?(model.alert)
        }
    }

}
