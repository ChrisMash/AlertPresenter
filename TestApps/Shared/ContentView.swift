//
//  ContentView.swift
//  Created by Chris Mash on 20/12/2020.
//

import SwiftUI
import AlertPresenter

class MyPopoverDelegate: NSObject, PopoverDelegate {
    #if os(iOS)
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        // forces the popover presentation style to be honoured on iPhone
        return .none
    }
    #endif
}

struct ContentView: View {
    
    private let alertPresenter = AlertPresenter()
    private let popoverDelegate = MyPopoverDelegate()
    #if os(iOS)
    private let buttonHeight: CGFloat = 25
    #else // tvOS
    private let buttonHeight: CGFloat = 70
    #endif
    
    
    let displayInfo: String
    
    var body: some View {
        VStack {
            Text(displayInfo)
            ForEach(AlertType.allCases, id: \.self) { type in
                GeometryReader { g in
                    VStack {
                        Button(type.buttonTitle()) {
                            showAlertControllers(type: type,
                                                 geometryProxy: g)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(maxHeight: buttonHeight)
            }
        }
    }
    
    private func showAlertControllers(type: AlertType, geometryProxy: GeometryProxy) {
        // Suitable for an example, but your use case may require the
        // window to be more carefully selected, especially if you
        // support multiple windows on iPad!
        let windowScene = UIApplication.shared.windows.first?.windowScene
        
        let alert1 = type.alert(index: 1)
        let alert2 = type.alert(index: 2)
        let popoverClosure: AlertPresenter.PopoverPresentationClosure?
        switch type {
        case .alert,
             .actionSheet,
             .custom:
            popoverClosure = nil
        #if os(iOS)
        case .actionSheetPositioned,
             .customPositioned:
            popoverClosure = { alert in
                let frame = geometryProxy.frame(in: .global)
                return PopoverPresentation(sourceRect: frame,
                                            delegate: popoverDelegate)
            }
            
            alert1.modalPresentationStyle = .popover
            alert2.modalPresentationStyle = .popover
        #endif // os(iOS)
        }
        
        alertPresenter.enqueue(alert: alert1,
                               windowScene: windowScene,
                               popoverPresentation: popoverClosure)
            
        alertPresenter.enqueue(alert: alert2,
                               windowScene: windowScene,
                               popoverPresentation: popoverClosure)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(displayInfo: "Title here")
    }
}
