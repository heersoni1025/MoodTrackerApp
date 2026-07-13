// Heer Soni - heersoni@iu.edu
// Carley Rodenbush - cjrodenb@iu.edu
// MoodTrackerApp
// 5 May, 2026

import Foundation
import Combine

final class ChartsViewModel: ObservableObject {
    @Published var chartData: [MoodChartData] = []
    @Published var averageMoodText: String = "N/A"
    @Published var bestMoodText: String = "N/A"
    @Published var worstMoodText: String = "N/A"
    @Published var recommendationText: String = "Save mood entries to see insights."
    @Published var averageMoodValue: Double = 0.0
    @Published var entryCount: Int = 0

    func refresh(entries: [MoodEntry]) {
        entryCount = entries.count

        let lastSeven = Array(entries.suffix(7))

        chartData = lastSeven.enumerated().map { index, entry in
            MoodChartData(
                label: "Entry \(index + 1)",
                moodScore: moodScore(for: entry.moodLabel),
                moodEmoji: entry.moodEmoji
            )
        }

        guard !lastSeven.isEmpty else {
            averageMoodText = "N/A"
            bestMoodText = "N/A"
            worstMoodText = "N/A"
            recommendationText = "Save mood entries to see insights."
            averageMoodValue = 0.0
            return
        }

        let scores = lastSeven.map { moodScore(for: $0.moodLabel) }
        let average = Double(scores.reduce(0, +)) / Double(scores.count)

        averageMoodValue = average
        averageMoodText = String(format: "%.1f / 5", average)

        if let best = lastSeven.max(by: { moodScore(for: $0.moodLabel) < moodScore(for: $1.moodLabel) }) {
            bestMoodText = best.moodLabel
        } else {
            bestMoodText = "N/A"
        }

        if let worst = lastSeven.min(by: { moodScore(for: $0.moodLabel) < moodScore(for: $1.moodLabel) }) {
            worstMoodText = worst.moodLabel
        } else {
            worstMoodText = "N/A"
        }

        switch average {
        case ..<2:
            recommendationText = "You seem to be having a rough stretch. Try resting and taking care of yourself."
        case ..<3.5:
            recommendationText = "Your mood looks mixed. A short break, walk, or reset may help."
        case ..<4.5:
            recommendationText = "You seem to be doing pretty well. Keep your routine going."
        default:
            recommendationText = "You seem to be doing great lately. Keep it up."
        }
    }

    private func moodScore(for label: String) -> Int {
        switch label {
        case "Very Bad": return 1
        case "Bad": return 2
        case "Ehh": return 3
        case "Good": return 4
        case "Happy!": return 5
        default: return 0
        }
    }
}
