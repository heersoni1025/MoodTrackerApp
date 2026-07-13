// Heer Soni - heersoni@iu.edu
// Carley Rodenbush - cjrodenb@iu.edu
// Jack Huynh - jackhuyn@iu.edu
// MoodTrackerApp
// 5 May, 2026

import SwiftUI
import SwiftData
import Charts

struct ChartsView: View {
    @ObservedObject var viewModel: ChartsViewModel

    @Query(sort: \MoodEntry.date)
    private var allEntries: [MoodEntry]

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        let latestSeven = Array(allEntries.suffix(7))

        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [
                        Color(red: 0.95, green: 0.97, blue: 1.0),
                        Color(red: 0.89, green: 0.96, blue: 1.0),
                        Color(red: 0.96, green: 0.92, blue: 1.0)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        headerCard
                        chartCard
                        statsSection
                        recommendationCard
                    }
                    .padding()
                }
            }
            .navigationTitle("Charts")
            .onAppear {
                viewModel.refresh(entries: latestSeven)
            }
            .onChange(of: allEntries.count) {
                viewModel.refresh(entries: Array(allEntries.suffix(7)))
            }
        }
    }

    var headerCard: some View {
        VStack(spacing: 8) {
            Text("Mood Insights")
                .font(.system(size: 30, weight: .heavy, design: .rounded))
                .foregroundColor(.white)

            Text("Your last 7 mood entries")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.9))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 28)
        .background(
            LinearGradient(
                colors: [
                    Color(red: 0.25, green: 0.31, blue: 0.92),
                    Color(red: 0.34, green: 0.67, blue: 0.96)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .shadow(color: .blue.opacity(0.25), radius: 12, y: 6)
    }

    var chartCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Mood Bar Chart")
                .font(.headline)

            if viewModel.chartData.isEmpty {
                Text("No chart data yet.")
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 40)
            } else {
                Chart {
                    ForEach(viewModel.chartData) { item in
                        BarMark(
                            x: .value("Entry", item.label),
                            y: .value("Mood Score", item.moodScore)
                        )
                        .foregroundStyle(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.28, green: 0.49, blue: 0.98),
                                    Color(red: 0.25, green: 0.76, blue: 0.95)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .cornerRadius(8)
                        .annotation(position: .top) {
                            Text(item.moodEmoji)
                                .font(.system(size: 18))
                        }
                    }

                    RuleMark(y: .value("Average", viewModel.averageMoodValue))
                        .foregroundStyle(Color.purple)
                        .lineStyle(StrokeStyle(lineWidth: 2, dash: [5]))
                }
                .frame(height: 280)
                .chartYScale(domain: 0...5)
            }
        }
        .padding()
        .background(Color.white.opacity(0.88))
        .clipShape(RoundedRectangle(cornerRadius: 26))
        .shadow(color: .black.opacity(0.06), radius: 8, y: 4)
    }

    var statsSection: some View {
        LazyVGrid(columns: columns, spacing: 14) {
            statCard(title: "Average Mood", value: viewModel.averageMoodText)
            statCard(title: "Best Mood", value: viewModel.bestMoodText)
            statCard(title: "Worst Mood", value: viewModel.worstMoodText)
            statCard(title: "Entries", value: "\(viewModel.entryCount)")
        }
    }

    func statCard(title: String, value: String) -> some View {
        VStack(spacing: 10) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)

            Text(value)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.black.opacity(0.8))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 110)
        .background(Color.white.opacity(0.88))
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .shadow(color: .black.opacity(0.06), radius: 8, y: 4)
    }

    var recommendationCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recommended Action")
                .font(.headline)
                .foregroundColor(Color(red: 0.25, green: 0.34, blue: 0.80))

            Text(viewModel.recommendationText)
                .foregroundColor(.black.opacity(0.78))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            LinearGradient(
                colors: [
                    Color(red: 0.88, green: 0.96, blue: 1.0),
                    Color(red: 0.94, green: 0.92, blue: 1.0)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
    }
}
