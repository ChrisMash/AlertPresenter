//
//  ContentView.swift
//  PodTestApp
//
//  Created by Chris Mash on 19/09/2021.
//

import SwiftUI
import AlertPresenter

struct ContentView: View {
    private var alertPresenter = AlertPresenter()
    
    var body: some View {
        Text("Hello, world!")
            .padding()
            .onAppear {
                let alert = UIAlertController(title: "Hey",
                                              message: "I'm an alert!",
                                              preferredStyle: .alert)
                let windowScene = UIApplication.shared.windows.first?.windowScene
                alertPresenter.enqueue(alert: alert,
                                       windowScene: windowScene)
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
