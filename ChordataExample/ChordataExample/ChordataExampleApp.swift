//
//  ChordataExampleApp.swift
//  ChordataExample
//
//  Created by Andrew Clunis on 2025-05-26.
//

import SwiftUI

@main
struct ChordataExampleApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
