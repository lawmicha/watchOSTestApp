//
//  ContentView.swift
//  watchOSTestApp Watch App
//
//  Created by Law, Michael on 2023-10-04.
//

import SwiftUI
import Amplify
import AWSPluginsCore
import AVFAudio

class SubscriptionViewModel: ObservableObject {
    
    var subscription: AmplifyAsyncThrowingSequence<GraphQLSubscriptionEvent<MutationSyncResult>>?
    
    func createSubscription() {
        subscription = Amplify.API.subscribe(request: .subscription(to: User.self, 
                                                                    subscriptionType: .onCreate))
        Task {
            do {
                guard let subscription = subscription else {
                    return
                }
                for try await subscriptionEvent in subscription {
                    switch subscriptionEvent {
                    case .connection(let subscriptionConnectionState):
                        print("Subscription connect state is \(subscriptionConnectionState)")
                    case .data(let result):
                        switch result {
                        case .success(let createdTodo):
                            print("Successfully got User from subscription: \(createdTodo)")
                        case .failure(let error):
                            print("Got failed result with \(error.errorDescription)")
                        }
                    }
                }
            } catch {
                print("Subscription has terminated with \(error)")
            }
        }
    }
    
    func cancelSubscription() {
        // Cancel the subscription listener when you're finished with it
        subscription?.cancel()
    }
}
struct ContentView: View {
    
    @ObservedObject var vm: SubscriptionViewModel = SubscriptionViewModel()
    
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
            
            Button("Create Sub") {
                Task {
                    vm.createSubscription()
                }
            }
            
            Button("Activate Audio") {
                do {
                    try AVAudioSession.sharedInstance().setCategory(.playback, 
                                                                    mode: .default,
                                                                    policy: .longFormAudio,
                                                                    options: [])
                } catch {
                    print("AVAudioSession setCategory error: \(error)")
                }

                AVAudioSession.sharedInstance().activate(options: [], completionHandler: { _, _ in 
                    // The audio route picket may be displayed before the completionHandler is called.
                    print("AVAudioSession activated.")
                })
            }
            
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
