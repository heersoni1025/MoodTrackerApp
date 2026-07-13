// Heer Soni - heersoni@iu.edu
// Carley Rodenbush - cjrodenb@iu.edu
// Jack Huynh - jackhuyn@iu.edu
// MoodTrackerApp
// 5 May, 2026

import Foundation
import SwiftData

@Model
final class MoodEntry {
    var id: UUID
    var moodEmoji: String
    var moodLabel: String
    var note: String
    var date: Date

    init(
        id: UUID = UUID(),
        moodEmoji: String,
        moodLabel: String,
        note: String,
        date: Date = Date()
    ) {
        self.id = id
        self.moodEmoji = moodEmoji
        self.moodLabel = moodLabel
        self.note = note
        self.date = date
    }
}
