//
//  ChordataExampleApp.swift
//  ChordataExample
//
//  Created by Andrew Clunis on 2025-05-26.
//

import SwiftUI
import os.log
import choredata

@main
struct ChordataExampleApp: App {
    let persistenceController = PersistenceController.shared

    init() {
        os_log("Starting Chordata Example app")
        ChoreDataManager.shared.initialize(persistentContainer: persistenceController.container)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
