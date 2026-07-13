// Heer Soni - heersoni@iu.edu
// Carley Rodenbush - cjrodenb@iu.edu
// Jack Huynh - jackhuyn@iu.edu
// MoodTrackerApp
// 5 May, 2026

import SwiftUI
import SwiftData

@main
struct MoodTrackerAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: MoodEntry.self)
    }
}
