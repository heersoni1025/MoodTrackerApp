// Heer Soni - heersoni@iu.edu
// Carley Rodenbush - cjrodenb@iu.edu
// Jack Huynh - jackhuyn@iu.edu
// MoodTrackerApp
// 5 May, 2026

import Foundation
import SwiftData
import Combine

final class HistoryViewModel: ObservableObject {
    func deleteEntries(at offsets: IndexSet, entries: [MoodEntry], context: ModelContext) {
        for index in offsets {
            context.delete(entries[index])
        }

        do {
            try context.save()
        } catch {
            print("Failed to delete entry: \(error.localizedDescription)")
        }
    }

    func formattedDate(for entry: MoodEntry) -> String {
        entry.date.formatted(date: .abbreviated, time: .shortened)
    }
}
