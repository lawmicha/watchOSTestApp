//
//  ContentView.swift
//  watchOSTestApp Watch App
//
//  Created by Law, Michael on 2023-10-04.
//

import SwiftUI
import Amplify

struct ContentView: View {
    var body: some View {
        ScrollView {
    
            Button("Start") {
                Task {
                    print("Starting")
                    try await Amplify.DataStore.start()
                }
            }
            
            Button("Stop") {
                Task {
                    print("Stopping")
                    try await Amplify.DataStore.stop()
                }
            }
            
            Button("Save") {
                Task {
                    print("Saving")
                    let user = User()
                    try await Amplify.DataStore.save(user)
                    let test = Test(userID: user.id)
                    try await Amplify.DataStore.save(test)
                }
            }
            
            Button("Clear") {
                Task {
                    print("Clearing")
                    try await Amplify.DataStore.clear()
                }
            }
            
            Button("Query") {
                Task {
                    print("Querying")
                    let users = try await Amplify.DataStore.query(User.self)
                    print(users)
                    let tests = try await Amplify.DataStore.query(Test.self)
                    print(tests)
                }
            }
            
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
