//
//  watchOSTestAppApp.swift
//  watchOSTestApp Watch App
//
//  Created by Law, Michael on 2023-10-04.
//
import Amplify
import AWSDataStorePlugin
import AWSAPIPlugin

import SwiftUI

@main
struct watchOSTestApp_Watch_AppApp: App {
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
