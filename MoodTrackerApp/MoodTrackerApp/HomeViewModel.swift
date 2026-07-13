// Heer Soni - heersoni@iu.edu
// Carley Rodenbush - cjrodenb@iu.edu
// MoodTrackerApp
// 5 May, 2026

import Foundation
import SwiftData
import Combine

final class HomeViewModel: ObservableObject {
    @Published var selectedMood: String = ""
    @Published var selectedEmoji: String = ""
    @Published var note: String = ""
    @Published var showSavedAlert: Bool = false

    let moods = [
        ("😡", "Very Bad"),
        ("☹️", "Bad"),
        ("😐", "Ehh"),
        ("🙂", "Good"),
        ("😄", "Happy!")
    ]

    func selectMood(emoji: String, label: String) {
        selectedEmoji = emoji
        selectedMood = label
    }

    func saveEntry(context: ModelContext) {
        guard !selectedMood.isEmpty else { return }

        let entry = MoodEntry(
            moodEmoji: selectedEmoji,
            moodLabel: selectedMood,
            note: note.trimmingCharacters(in: .whitespacesAndNewlines),
            date: Date()
        )

        context.insert(entry)

        do {
            try context.save()
            selectedMood = ""
            selectedEmoji = ""
            note = ""
            showSavedAlert = true
        } catch {
            print("Failed to save entry: \(error.localizedDescription)")
        }
    }
}
