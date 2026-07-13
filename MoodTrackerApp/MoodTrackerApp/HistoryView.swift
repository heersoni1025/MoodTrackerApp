// Heer Soni - heersoni@iu.edu
// Carley Rodenbush - cjrodenb@iu.edu
// Jack Huynh - jackhuyn@iu.edu
// MoodTrackerApp
// 5 May, 2026

import SwiftUI
import SwiftData

struct HistoryView: View {
    @ObservedObject var viewModel: HistoryViewModel
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \MoodEntry.date, order: .reverse)
    private var entries: [MoodEntry]

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [
                        Color(red: 0.97, green: 0.98, blue: 1.0),
                        Color(red: 0.92, green: 0.97, blue: 1.0)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                if entries.isEmpty {
                    VStack(spacing: 18) {
                        Image(systemName: "clock.arrow.circlepath")
                            .font(.system(size: 60))
                            .foregroundColor(Color(red: 0.23, green: 0.39, blue: 0.83))

                        Text("No mood history yet")
                            .font(.system(size: 28, weight: .bold, design: .rounded))

                        Text("Save a mood entry on the Home tab and it will appear here.")
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding()
                } else {
                    List {
                        Section {
                            ForEach(entries.prefix(7)) { entry in
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack {
                                        Text(entry.moodEmoji)
                                            .font(.system(size: 34))

                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(entry.moodLabel)
                                                .font(.headline)

                                            Text(viewModel.formattedDate(for: entry))
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }

                                        Spacer()
                                    }

                                    if !entry.note.isEmpty {
                                        Text(entry.note)
                                            .font(.body)
                                            .foregroundColor(.black.opacity(0.75))
                                    }
                                }
                                .padding(.vertical, 6)
                            }
                            .onDelete { offsets in
                                let limitedEntries = Array(entries.prefix(7))
                                viewModel.deleteEntries(
                                    at: offsets,
                                    entries: limitedEntries,
                                    context: modelContext
                                )
                            }
                        } header: {
                            Text("Last 7 Entries")
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                }
            }
            .navigationTitle("History")
        }
    }
}
