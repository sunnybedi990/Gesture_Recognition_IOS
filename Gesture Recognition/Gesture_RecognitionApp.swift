//
//  Gesture_RecognitionApp.swift
//  Gesture Recognition
//
//  Created by sunny bedi on 5/31/24.
//

import SwiftUI

@main
struct Gesture_RecognitionApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
