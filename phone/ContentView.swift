//
//  ContentView.swift
//  watchOSTestApp Watch App
//
//  Created by Law, Michael on 2023-10-04.
//

import SwiftUI
import Amplify
import AWSPluginsCore

class SaveDeleteViewModel: ObservableObject {
    
    var savedId: String?
    
    func save() async throws {
        let user = User()
        
        try await Amplify.DataStore.save(user)
        self.savedId = user.id
    }
    
    func delete() async throws {
        if let id = savedId {
            try await Amplify.DataStore.delete(User.self, withId: id)
        }
    }
    
    func query() async throws {
        if let id = savedId {
            let results = try await Amplify.DataStore.query(User.self, byId: id)
            print("\(results)")
            
            let metadata = try await Amplify.DataStore.query(MutationSyncMetadata.self, byId: MutationSyncMetadata.identifier(modelName: User.modelName, modelId: id))
            print("\(metadata)")
            
        }
    }
}
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
    @ObservedObject var savedDeleteVM: SaveDeleteViewModel = SaveDeleteViewModel()
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
                    try await savedDeleteVM.save()
                }
            }
            
            Button("Delete saved") {
                Task {
                    try await savedDeleteVM.delete()
                }
            }
            
            Button("Query saved") {
                Task {
                    try await savedDeleteVM.query()
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
            
            Button("Print DB Path") {
                // print out DB path
                print(DataStoreDebugger.dbFilePath)
                
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
import Foundation
import Amplify
@testable import AWSDataStorePlugin

struct DataStoreDebugger {
    
    static var dbFilePath: URL? { getAdapter()?.dbFilePath }
    
    static func getAdapter() -> SQLiteStorageEngineAdapter? {
        if let dataStorePlugin = tryGetPlugin(),
           let storageEngine = dataStorePlugin.storageEngine as? StorageEngine,
           let adapter = storageEngine.storageAdapter as? SQLiteStorageEngineAdapter {
            return adapter
        }
        
        print("Could not get `SQLiteStorageEngineAdapter` from DataStore")
        return nil
    }
    
    static func tryGetPlugin() -> AWSDataStorePlugin? {
        do {
            return try Amplify.DataStore.getPlugin(for: "awsDataStorePlugin") as? AWSDataStorePlugin
        } catch {
            return nil
        }
    }
}
