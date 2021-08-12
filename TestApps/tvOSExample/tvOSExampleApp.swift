//
//  tvOSExampleApp.swift
//  Created by Chris Mash on 20/12/2020.
//

import SwiftUI

@main
struct tvOSExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(displayInfo: "tvOS \(UIDevice.current.systemVersion), SwiftUI (with App)")
        }
    }
}
