// Heer Soni - heersoni@iu.edu
// Carley Rodenbush - cjrodenb@iu.edu
// MoodTrackerApp
// 5 May, 2026

import Foundation

struct MoodChartData: Identifiable {
    let id = UUID()
    let label: String
    let moodScore: Int
    let moodEmoji: String
}
