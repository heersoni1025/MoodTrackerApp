// Heer Soni - heersoni@iu.edu
// Carley Rodenbush - cjrodenb@iu.edu
// MoodTrackerApp
// 5 May, 2026

import SwiftUI
import SwiftData

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    @ObservedObject var notificationManager: NotificationManager
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.96, green: 0.98, blue: 1.0),
                    Color(red: 0.90, green: 0.96, blue: 1.0),
                    Color(red: 0.97, green: 0.94, blue: 1.0)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    headerSection
                    questionSection
                    moodButtonsSection
                    noteSection
                    saveButtonSection
                    reminderButtonSection
                }
                .padding(.horizontal, 18)
                .padding(.top, 10)
                .padding(.bottom, 30)
            }
        }
        .alert("Mood saved!", isPresented: $viewModel.showSavedAlert) {
            Button("OK", role: .cancel) { }
        }
    }

    var headerSection: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.28, green: 0.19, blue: 0.86),
                    Color(red: 0.47, green: 0.29, blue: 0.97)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            VStack(spacing: 8) {
                Text("MOOD TRACKER")
                    .font(.system(size: 30, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)

                Text("Track your day, one feeling at a time")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.92))
            }
            .multilineTextAlignment(.center)
            .padding()
        }
        .frame(height: 145)
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .shadow(color: .purple.opacity(0.25), radius: 12, y: 8)
    }

    var questionSection: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.27, green: 0.86, blue: 0.96),
                    Color(red: 0.50, green: 0.92, blue: 0.96)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )

            Text("How are you feeling today?")
                .font(.system(size: 26, weight: .bold, design: .rounded))
                .foregroundColor(.black.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding()
        }
        .frame(height: 110)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: .blue.opacity(0.15), radius: 8, y: 5)
    }

    var moodButtonsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Pick your mood")
                .font(.headline)
                .foregroundColor(.black.opacity(0.75))

            HStack(spacing: 10) {
                ForEach(viewModel.moods, id: \.1) { mood in
                    Button {
                        viewModel.selectMood(emoji: mood.0, label: mood.1)
                    } label: {
                        VStack(spacing: 8) {
                            Text(mood.0)
                                .font(.system(size: 34))

                            Text(mood.1)
                                .font(.caption2)
                                .fontWeight(.semibold)
                                .foregroundColor(.black.opacity(0.72))
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(viewModel.selectedMood == mood.1 ? Color.white : Color.white.opacity(0.72))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(
                                    viewModel.selectedMood == mood.1
                                    ? Color(red: 0.39, green: 0.45, blue: 0.97)
                                    : Color.clear,
                                    lineWidth: 3
                                )
                        )
                        .shadow(color: .black.opacity(0.06), radius: 6, y: 4)
                        .scaleEffect(viewModel.selectedMood == mood.1 ? 1.03 : 1.0)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(18)
        .background(Color.white.opacity(0.52))
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }

    var noteSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Add a note")
                .font(.headline)
                .foregroundColor(.black.opacity(0.75))

            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 28)
                    .fill(Color.white.opacity(0.9))
                    .overlay(
                        RoundedRectangle(cornerRadius: 28)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.40, green: 0.66, blue: 0.98),
                                        Color(red: 0.56, green: 0.86, blue: 0.92)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ),
                                lineWidth: 2
                            )
                    )
                    .shadow(color: .black.opacity(0.05), radius: 8, y: 4)

                if viewModel.note.isEmpty {
                    Text("Write about your day...")
                        .foregroundColor(.gray)
                        .font(.system(size: 18))
                        .padding(.top, 18)
                        .padding(.leading, 18)
                }

                TextEditor(text: $viewModel.note)
                    .padding(12)
                    .frame(height: 180)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
            }
            .frame(height: 180)
        }
        .padding(18)
        .background(Color.white.opacity(0.52))
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }

    var saveButtonSection: some View {
        Button {
            viewModel.saveEntry(context: modelContext)
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "sparkles")
                Text("SAVE ENTRY")
                    .fontWeight(.bold)
            }
            .font(.system(size: 22, design: .rounded))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 62)
            .background(
                LinearGradient(
                    colors: [
                        Color(red: 0.28, green: 0.49, blue: 0.98),
                        Color(red: 0.25, green: 0.76, blue: 0.95)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(Capsule())
            .shadow(color: .blue.opacity(0.25), radius: 10, y: 5)
        }
    }

    var reminderButtonSection: some View {
        Button {
            notificationManager.openNotificationSettings()
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "bell.badge.fill")
                Text("OPEN NOTIFICATION SETTINGS")
                    .fontWeight(.bold)
            }
            .font(.system(size: 18, design: .rounded))
            .foregroundColor(Color(red: 0.28, green: 0.19, blue: 0.76))
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(Color.white.opacity(0.78))
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(Color(red: 0.58, green: 0.65, blue: 0.95), lineWidth: 2)
            )
        }
    }
}
