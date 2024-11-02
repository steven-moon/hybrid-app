//
//  Hybrid_iOS_AppApp.swift
//  Hybrid-iOS-App
//
//  Created by Steven Moon on 11/1/24.
//

import SwiftUI

@main
struct Hybrid_iOS_AppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
