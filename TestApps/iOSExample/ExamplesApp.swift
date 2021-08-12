//
//  ExamplesApp.swift
//  Created by Chris Mash on 20/12/2020.
//

import SwiftUI

@main
struct ExamplesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(displayInfo: "iOS \(UIDevice.current.systemVersion), SwiftUI (with App)")
        }
    }
}
