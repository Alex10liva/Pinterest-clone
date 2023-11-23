//
//  NC1_PinterestApp.swift
//  NC1-Pinterest
//
//  Created by Alejandro Oliva Ochoa on 13/11/23.
//

import SwiftUI
import SwiftData

@main
struct NC1_PinterestApp: App {
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Pin.self,
            Board.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
