//
//  phoneApp.swift
//  phone
//
//  Created by Michael Law on 11/15/23.
//

import Amplify
import AWSDataStorePlugin
import AWSAPIPlugin

import SwiftUI

@main
struct phoneApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    init() {
        do {
            Amplify.Logging.logLevel = .verbose
            // AmplifyModels is generated in the previous step
            let dataStorePlugin = AWSDataStorePlugin(modelRegistration: AmplifyModels())
            try Amplify.add(plugin: dataStorePlugin)
            try Amplify.add(plugin: AWSAPIPlugin())
            try Amplify.configure()
            print("Amplify configured with DataStore plugin")
        } catch {
            print("Failed to initialize Amplify with \(error)")
        }
    }
}
