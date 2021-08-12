//
//  PopoverPresentation.swift
//  Created by Chris Mash on 13/07/2021.
//

import UIKit

#if os(iOS)
/// Delegate protocol assigned to the alert's popover presentation controller, if present on iOS. On tvOS this protocol does nothing.
@objc public protocol PopoverDelegate: UIPopoverPresentationControllerDelegate {}
#else // tvOS, no UIPopoverPresentationControllerDelegate available
/// Delegate protocol assigned to the alert's popover presentation controller, if present on iOS. On tvOS this protocol does nothing.
@objc public protocol PopoverDelegate {}
#endif

/// Object describing the presentation of an alert when shown in a popover, such as an
/// action sheet on iPad.
public class PopoverPresentation: NSObject {
    
    /// The position on the screen to anchor the alert to.
    let sourceRect: CGRect?
    /// Optional delegate to assign to the popover presentation controller.
    weak var delegate: PopoverDelegate?
    /// Permitted arrow directions for the popover. If `sourceRect` is nil no arrow will be shown, otherwise any
    /// direction is permitted.
    let arrowDirections: UIPopoverArrowDirection
    
    /// Initialises the object with the specified parameters
    /// - parameter sourceRect: the position on the screen to anchor the alert to. Passing `.zero` will
    /// result in the parameter being ignored and the default position in the center of the screen being used.
    /// - parameter delegate: the optional delegate to assign to the popover presentation controller. Note that
    /// this parameter has no use on tvOS.
    @objc public init(sourceRect: CGRect,
                      delegate: PopoverDelegate?) {
        self.sourceRect = sourceRect == .zero ? nil : sourceRect
        self.arrowDirections = self.sourceRect == nil ? .init(rawValue: 0) : .any
        self.delegate = delegate
        super.init()
    }
    
}
